import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '/backend/supabase/supabase.dart';
import '/floter/floter_theme.dart';

class ProfilePhotoGrid extends StatelessWidget {
  const ProfilePhotoGrid({
    super.key,
    this.mainPhotoUrl,
    required this.gridSlots,
    this.onMainPhotoChanged,
    required this.onGridPhotoChanged,
    this.showMainPhoto = true,
    this.showGrid = true,
  });

  final String? mainPhotoUrl;
  final List<String> gridSlots;
  final ValueChanged<String?>? onMainPhotoChanged;
  final ValueChanged<List<String>> onGridPhotoChanged;
  final bool showMainPhoto;
  final bool showGrid;

  bool get _hasMainPhoto =>
      mainPhotoUrl != null && mainPhotoUrl!.trim().isNotEmpty;
  bool get _isEmptyMainPhoto =>
      mainPhotoUrl == null || mainPhotoUrl!.trim().isEmpty;

  bool _isFilledSlot(String slot) {
    return slot.isNotEmpty &&
        slot != '__add_photo__' &&
        slot != '__empty_photo__';
  }

  static String? _storagePathFromPublicUrl(String photoUrl) {
    final uri = Uri.tryParse(photoUrl.trim());
    if (uri == null) return null;
    const marker = '/storage/v1/object/public/user_photos/';
    final index = uri.path.indexOf(marker);
    if (index < 0) return null;
    final encodedPath = uri.path.substring(index + marker.length);
    return Uri.decodeComponent(encodedPath);
  }

  static List<String> _buildGridSlots(List<String> photoUrls) {
    final compact = photoUrls
        .map((url) => url.trim())
        .where((url) => url.isNotEmpty)
        .take(6)
        .toList();
    final slots = <String>[...compact];
    final visibleSlots = compact.length < 3 ? 3 : 6;
    if (compact.length < 6) {
      slots.add('__add_photo__');
    }
    while (slots.length < visibleSlots) {
      slots.add('__empty_photo__');
    }
    return slots;
  }

  Future<List<Map<String, dynamic>>> _loadPhotoRows(String userId) async {
    final rows = await SupaFlow.client
        .from('user_photos')
        .select('id, photo_url, slot, order')
        .eq('user_id', userId)
        .order('slot', ascending: true)
        .order('order', ascending: true)
        .limit(6);
    return rows
        .map<Map<String, dynamic>>((row) => Map<String, dynamic>.from(row))
        .toList();
  }

  Future<void> _refreshGrid(String userId) async {
    final rows = await _loadPhotoRows(userId);
    final urls = rows
        .map((row) => SupaFlow.resolvePhotoUrl(row['photo_url']) ?? '')
        .where((url) => url.isNotEmpty)
        .toList();
    onGridPhotoChanged(_buildGridSlots(urls));
  }

  Future<void> _compactGridPhotoSlots(String userId) async {
    final rows = await _loadPhotoRows(userId);
    for (var index = 0; index < rows.length; index++) {
      final row = rows[index];
      final id = row['id'];
      if (id == null) continue;

      final nextSlot = index + 1;
      if (row['slot'] == nextSlot && row['order'] == nextSlot) {
        continue;
      }

      await SupaFlow.client
          .from('user_photos')
          .update({
            'slot': nextSlot,
            'order': nextSlot,
            'position': nextSlot,
          })
          .eq('id', id)
          .eq('user_id', userId);
    }
  }

  Future<Uint8List?> _pickFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked == null) return null;
    return await picked.readAsBytes();
  }

  Future<Uint8List?> _pickFromCamera() async {
    final picker = ImagePicker();
    try {
      final picked = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked == null) return null;
      return await picked.readAsBytes();
    } catch (_) {
      return null;
    }
  }

  Future<Uint8List?> _pickPhotoBytes(BuildContext context) async {
    final source = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add photo'),
        content: const Text('Choose source'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'camera'),
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'gallery'),
            child: const Text('Gallery'),
          ),
        ],
      ),
    );

    try {
      if (source == 'camera') return await _pickFromCamera();
      if (source == 'gallery') return await _pickFromGallery();
      return null;
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera access denied. Enable it in Settings.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      return null;
    }
  }

  Future<String?> _uploadBytesToStorage(Uint8List bytes) async {
    final userId = SupaFlow.client.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) return null;

    final createDataTime = DateTime.now().millisecondsSinceEpoch.toString();
    final storagePath = '$userId/$createDataTime';

    final storageBucket = SupaFlow.client.storage.from('user_photos');
    await storageBucket.uploadBinary(storagePath, bytes);
    return storagePath;
  }

  Future<void> _uploadMainPhoto(BuildContext context) async {
    final bytes = await _pickPhotoBytes(context);
    if (bytes == null || bytes.isEmpty) return;

    final userId = SupaFlow.client.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) return;

    try {
      final storagePath = await _uploadBytesToStorage(bytes);
      if (storagePath == null) return;
      await SupaFlow.client
          .from('profiles')
          .update({'avatar_url': storagePath}).eq('user_id', userId);
      final uploadedUrl = SupaFlow.userPhotoUrl(storagePath);
      onMainPhotoChanged?.call(uploadedUrl);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload photo: $error')),
      );
    }
  }

  Future<void> _removeMainPhoto(BuildContext context) async {
    if (!_hasMainPhoto) return;
    final userId = SupaFlow.client.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) return;
    try {
      final storagePath = _storagePathFromPublicUrl(mainPhotoUrl ?? '');
      await SupaFlow.client
          .from('profiles')
          .update({'avatar_url': ''}).eq('user_id', userId);
      if (storagePath != null && storagePath.isNotEmpty) {
        await SupaFlow.client.storage.from('user_photos').remove([storagePath]);
      }
      onMainPhotoChanged?.call('');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  Future<void> _deleteGridPhoto(BuildContext context, String photoUrl) async {
    final selectedUrl = photoUrl.trim();
    if (selectedUrl.isEmpty ||
        selectedUrl == '__add_photo__' ||
        selectedUrl == '__empty_photo__') {
      return;
    }

    final userId = SupaFlow.client.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) return;

    try {
      final storagePath = _storagePathFromPublicUrl(selectedUrl);

      await SupaFlow.client
          .from('user_photos')
          .delete()
          .eq('user_id', userId)
          .eq('photo_url', storagePath ?? '');

      if (storagePath != null && storagePath.isNotEmpty) {
        await SupaFlow.client.storage.from('user_photos').remove([storagePath]);
      }

      await _compactGridPhotoSlots(userId);
      await _refreshGrid(userId);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  Future<void> _uploadGridPhoto(BuildContext context) async {
    final bytes = await _pickPhotoBytes(context);
    if (bytes == null || bytes.isEmpty) return;

    final userId = SupaFlow.client.auth.currentUser?.id;
    if (userId == null || userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not authenticated')),
      );
      return;
    }

    final existingRows = await _loadPhotoRows(userId);
    final existingUrls = existingRows
        .map((row) => (row['photo_url'] as String?)?.trim() ?? '')
        .where((url) => url.isNotEmpty)
        .toList();
    if (existingUrls.length >= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 6 photos')),
      );
      return;
    }

    final existingSlots =
        existingRows.map((row) => row['slot']).whereType<int>().toList();
    final nextSlot = List<int>.generate(6, (index) => index + 1).firstWhere(
      (slot) => !existingSlots.contains(slot),
      orElse: () => existingUrls.length + 1,
    );

    try {
      final storagePath = await _uploadBytesToStorage(bytes);
      if (storagePath == null) return;
      await SupaFlow.client.from('user_photos').insert({
        'user_id': userId,
        'position': nextSlot,
        'photo_url': storagePath,
        'slot': nextSlot,
        'order': nextSlot,
      });
      await _refreshGrid(userId);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  Widget _buildDeleteButton(
    FloterTheme theme, {
    required VoidCallback onTap,
  }) {
    return Positioned(
      top: -8.0,
      right: -8.0,
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          width: 42.0,
          height: 42.0,
          decoration: BoxDecoration(
            color: theme.alternate,
            borderRadius: BorderRadius.circular(21.0),
          ),
          alignment: const AlignmentDirectional(0.0, 0.0),
          child: Icon(
            Icons.close,
            color: theme.primaryBackground,
            size: 28.0,
          ),
        ),
      ),
    );
  }

  Widget _buildMainPhoto(BuildContext context, FloterTheme theme) {
    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: const AlignmentDirectional(1, -1),
          children: [
            if (_hasMainPhoto)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SupaPhoto(
                    imageSource: mainPhotoUrl!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (_isEmptyMainPhoto)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.primaryBackground,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: theme.primaryText,
                      width: 1,
                    ),
                  ),
                  alignment: const AlignmentDirectional(0, 0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => _uploadMainPhoto(context),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: theme.alternate,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      alignment: const AlignmentDirectional(0, 0),
                      child: Icon(
                        Icons.add,
                        color: theme.primaryBackground,
                        size: 44,
                      ),
                    ),
                  ),
                ),
              ),
            if (_hasMainPhoto)
              _buildDeleteButton(
                theme,
                onTap: () => _removeMainPhoto(context),
              ),
          ],
        ),
      ),
    );
  }

  List<String> get _effectiveSlots {
    if (gridSlots.isNotEmpty) return gridSlots;
    return _buildGridSlots(const []);
  }

  Widget _buildGrid(BuildContext outerContext, FloterTheme theme) {
    final slots = _effectiveSlots;
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 1.0,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: const AlignmentDirectional(0.0, 0.0),
            children: [
              if (_isFilledSlot(slot))
                Positioned.fill(
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: const AlignmentDirectional(1.0, -1.0),
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: SupaPhoto(
                            imageSource: slot,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      _buildDeleteButton(
                        theme,
                        onTap: () => _deleteGridPhoto(outerContext, slot),
                      ),
                    ],
                  ),
                ),
              if (slot == '__add_photo__')
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.primaryBackground,
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: theme.primaryText,
                        width: 1.0,
                      ),
                    ),
                    alignment: const AlignmentDirectional(0.0, 0.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () => _uploadGridPhoto(outerContext),
                      child: Container(
                        width: 56.0,
                        height: 56.0,
                        decoration: BoxDecoration(
                          color: theme.alternate,
                          borderRadius: BorderRadius.circular(28.0),
                        ),
                        alignment: const AlignmentDirectional(0.0, 0.0),
                        child: Icon(
                          Icons.add,
                          color: theme.primaryBackground,
                          size: 44.0,
                        ),
                      ),
                    ),
                  ),
                ),
              if (slot == '__empty_photo__')
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.primaryBackground,
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: theme.alternate,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FloterTheme.of(context);
    if (!showMainPhoto) {
      return _buildGrid(context, theme);
    }
    if (!showGrid) {
      return _buildMainPhoto(context, theme);
    }
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMainPhoto(context, theme),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: _buildGrid(context, theme),
        ),
      ],
    );
  }
}
