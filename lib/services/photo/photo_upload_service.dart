import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:image_picker/image_picker.dart';

import '/backend/supabase/supabase.dart';

class PhotoUploadResult {
  const PhotoUploadResult({
    required this.storagePath,
    required this.publicUrl,
  });

  final String storagePath;
  final String publicUrl;
}

class PhotoUploadService {
  const PhotoUploadService();

  Future<PhotoUploadResult?> pickAndUploadUserPhoto(
    BuildContext context, {
    required String userId,
  }) {
    return _pickAndUpload(
      context,
      userId: userId,
      bucket: 'user_photos',
      publicUrlForPath: SupaFlow.userPhotoUrl,
    );
  }

  Future<PhotoUploadResult?> pickAndUploadChatPhoto(
    BuildContext context, {
    required String userId,
  }) {
    return _pickAndUpload(
      context,
      userId: userId,
      bucket: 'chat_photos',
      publicUrlForPath: SupaFlow.chatPhotoUrl,
    );
  }

  Future<PhotoUploadResult?> _pickAndUpload(
    BuildContext context, {
    required String userId,
    required String bucket,
    required String Function(String storagePath) publicUrlForPath,
  }) async {
    if (userId.trim().isEmpty) {
      _showSnackBar(context, 'User is not authenticated');
      return null;
    }

    final source = await _chooseSource(context);
    if (source == null || !context.mounted) return null;

    final picked = await _pickImage(context, source);
    if (picked == null || !context.mounted) return null;

    try {
      final file = _uploadFileFromBytes(picked.bytes);
      final storagePath = _storagePath(
        userId: userId,
        source: source,
        extension: file.extension,
      );

      await SupaFlow.client.storage.from(bucket).uploadBinary(
            storagePath,
            picked.bytes,
            fileOptions: FileOptions(
              contentType: file.contentType,
              cacheControl: '3600',
            ),
          );

      return PhotoUploadResult(
        storagePath: storagePath,
        publicUrl: publicUrlForPath(storagePath),
      );
    } catch (error) {
      if (context.mounted) {
        _showSnackBar(context, 'Failed to upload photo: $error');
      }
      return null;
    }
  }

  Future<ImageSource?> _chooseSource(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: Color(0xFFC9B0FF),
                  ),
                  title: const Text('Gallery'),
                  onTap: () => Navigator.pop(ctx, ImageSource.gallery),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: Color(0xFFC9B0FF),
                  ),
                  title: const Text('Camera'),
                  onTap: () => Navigator.pop(ctx, ImageSource.camera),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<_PickedImage?> _pickImage(
    BuildContext context,
    ImageSource source,
  ) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 88,
      );
      if (picked == null) return null;

      final bytes = await picked.readAsBytes();
      if (!context.mounted) return null;
      if (bytes.isEmpty) {
        _showSnackBar(context, 'Selected file is empty');
        return null;
      }

      return _PickedImage(bytes);
    } on PlatformException catch (error) {
      if (context.mounted) {
        _showSnackBar(context, _pickerErrorMessage(error, source));
      }
      return null;
    } catch (error) {
      if (context.mounted) {
        _showSnackBar(context, 'Failed to select photo: $error');
      }
      return null;
    }
  }

  _UploadFile _uploadFileFromBytes(Uint8List bytes) {
    if (_isJpeg(bytes)) {
      return const _UploadFile(extension: 'jpg', contentType: 'image/jpeg');
    }
    if (_isPng(bytes)) {
      return const _UploadFile(extension: 'png', contentType: 'image/png');
    }
    if (_isWebp(bytes)) {
      return const _UploadFile(extension: 'webp', contentType: 'image/webp');
    }
    return const _UploadFile(extension: 'jpg', contentType: 'image/jpeg');
  }

  bool _isJpeg(Uint8List bytes) {
    return bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF;
  }

  bool _isPng(Uint8List bytes) {
    return bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0D &&
        bytes[5] == 0x0A &&
        bytes[6] == 0x1A &&
        bytes[7] == 0x0A;
  }

  bool _isWebp(Uint8List bytes) {
    return bytes.length >= 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50;
  }

  String _storagePath({
    required String userId,
    required ImageSource source,
    required String extension,
  }) {
    final timestamp = DateTime.now().toUtc().microsecondsSinceEpoch;
    final sourceName = source == ImageSource.camera ? 'camera' : 'gallery';
    return '$userId/$timestamp-$sourceName.$extension';
  }

  String _pickerErrorMessage(PlatformException error, ImageSource source) {
    final code = error.code.toLowerCase();
    final message = (error.message ?? '').toLowerCase();
    final sourceName = source == ImageSource.camera ? 'Camera' : 'Gallery';
    if (code.contains('denied') ||
        code.contains('restricted') ||
        code.contains('permission') ||
        message.contains('denied') ||
        message.contains('permission')) {
      return '$sourceName access denied. Enable it in Settings.';
    }
    return 'Failed to select photo: ${error.message ?? error.code}';
  }

  void _showSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class _PickedImage {
  const _PickedImage(this.bytes);

  final Uint8List bytes;
}

class _UploadFile {
  const _UploadFile({
    required this.extension,
    required this.contentType,
  });

  final String extension;
  final String contentType;
}
