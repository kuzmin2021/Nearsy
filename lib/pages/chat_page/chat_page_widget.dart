import 'dart:typed_data';

import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as emoji;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'chat_page_model.dart';
import '/models/chat_models.dart';

import '/backend/supabase/supabase.dart';
export 'chat_page_model.dart';

class ChatPageWidget extends StatefulWidget {
  const ChatPageWidget({
    super.key,
    this.conversationId,
  });

  final int? conversationId;

  static String routeName = 'ChatPage';
  static String routePath = '/chat';

  @override
  State<ChatPageWidget> createState() => _ChatPageWidgetState();
}

class _ChatPageWidgetState extends State<ChatPageWidget> {
  late ChatPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatPageModel());
    _model.onStateChanged = () => safeSetState(() {});
    _model.setConversationId(widget.conversationId);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FloterTheme.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                Expanded(
                  child: _model.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _model.messages.isEmpty
                          ? Center(
                              child: Text(
                                AppLabels.of(context).get('chat.no_messages'),
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : _buildMessageList(context),
                ),
                const SizedBox(height: 8),
                _buildInputBar(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final nameParts = <String>[];
    if (_model.partnerName != null && _model.partnerName!.isNotEmpty) {
      nameParts.add(_model.partnerName!);
      if (_model.partnerAge != null) {
        nameParts.add('${_model.partnerAge}');
      }
    } else {
      nameParts.add(AppLabels.of(context).get('skip'));
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FloterIconButton(
          borderRadius: 8,
          buttonSize: 48,
          fillColor: Colors.transparent,
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 32,
          ),
          onPressed: () async {
            context.pop();
          },
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: SupaPhoto(
            imageSource: _model.partnerAvatar,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            placeholder: Container(
              color: FloterTheme.of(context).secondaryBackground,
              child: const Icon(Icons.person, size: 24),
            ),
            errorWidget: Container(
              color: FloterTheme.of(context).secondaryBackground,
              child: const Icon(Icons.person, size: 24),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Text(
          nameParts.join(', '),
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageList(BuildContext context) {
    return ListView.builder(
      controller: _model.scrollController,
      reverse: false,
      itemCount: _model.messages.length,
      itemBuilder: (context, index) {
        final msg = _model.messages[index];
        final timeStr = DateFormat('h:mma').format(msg.createdAt).toLowerCase();
        final theme = FloterTheme.of(context);

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: msg.isOwn
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7),
                decoration: BoxDecoration(
                  color: msg.isOwn ? const Color(0xFFC9B0FF) : const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (msg.body.isNotEmpty)
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  msg.body,
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ).copyWith(fontFamilyFallback: const ['NotoColorEmoji']),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildTimeStamp(msg, timeStr),
                            ],
                          ),
                        ),
                      if (msg.photoUrl != null && msg.photoUrl!.isNotEmpty)
                        Padding(
                          padding: msg.body.isNotEmpty
                              ? const EdgeInsets.only(top: 4)
                              : EdgeInsets.zero,
                          child: GestureDetector(
                            onTap: () => _showFullscreenPhoto(context, msg.photoUrl!),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: SupaPhoto(
                                imageSource: msg.photoUrl!,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                placeholder: const SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ),
                                errorWidget: Container(
                                  width: 120,
                                  height: 120,
                                  color: theme.secondaryBackground,
                                  child: const Icon(Icons.broken_image),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (msg.photoUrl != null && msg.photoUrl!.isNotEmpty && msg.body.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: _buildTimeStamp(msg, timeStr),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeStamp(Message msg, String timeStr) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (msg.isOwn) ...[
          Icon(
            Icons.check,
            size: 10,
            color: msg.isRead ? const Color(0xFF34C759) : const Color(0x80000000),
          ),
          const SizedBox(width: 3),
        ],
        Text(
          timeStr,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: const Color(0x80000000),
          ).copyWith(fontFamilyFallback: const ['NotoColorEmoji']),
        ),
      ],
    );
  }

  void _showEmojiPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: emoji.EmojiPicker(
            config: const emoji.Config(
              categoryViewConfig: emoji.CategoryViewConfig(
                recentTabBehavior: emoji.RecentTabBehavior.NONE,
              ),
            ),
            onEmojiSelected: (category, emoji) {
              final controller = _model.messageTextFieldTextController;
              final text = controller.text;
              final selection = controller.selection;
              final start = selection.start < 0 ? text.length : selection.start;
              final end = selection.end < 0 ? text.length : selection.end;
              final newText = text.replaceRange(start, end, emoji.emoji);
              controller.value = TextEditingValue(
                text: newText,
                selection: TextSelection.collapsed(
                  offset: start + emoji.emoji.length,
                ),
              );
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _showAttachmentPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Color(0xFFC9B0FF)),
                  title: const Text('Gallery'),
                  onTap: () async {
                    Navigator.pop(ctx);
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(source: ImageSource.gallery);
                    if (picked == null) return;
                    final bytes = await picked.readAsBytes();
                    await _model.sendPhoto(bytes, picked.name);
                    safeSetState(() {});
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Color(0xFFC9B0FF)),
                  title: const Text('Camera'),
                  onTap: () async {
                    Navigator.pop(ctx);
                    final picker = ImagePicker();
                    try {
                      final picked = await picker.pickImage(source: ImageSource.camera);
                      if (picked == null) return;
                      final bytes = await picked.readAsBytes();
                      await _model.sendPhoto(bytes, picked.name);
                      safeSetState(() {});
                    } catch (_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Camera access denied. Enable it in Settings.'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFullscreenPhoto(BuildContext context, String photoUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: SupaPhoto(
                  imageSource: photoUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: const Icon(Icons.broken_image, size: 64, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
          child: GestureDetector(
            onTap: () => _showAttachmentPicker(context),
            child: const Icon(
              Icons.attach_file,
              color: Color(0x80000000),
              size: 28,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFfffffffa),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _model.messageTextFieldTextController,
                    focusNode: _model.messageTextFieldFocusNode,
                    onChanged: (_) => EasyDebounce.debounce(
                      '_model.messageTextFieldTextController',
                      const Duration(milliseconds: 2000),
                      () async {
                        _model.messageText =
                            _model.messageTextFieldTextController.text;
                        safeSetState(() {});
                      },
                    ),
                    onFieldSubmitted: (_) async {
                      await _model.sendMessage();
                      safeSetState(() {});
                    },
                    textInputAction: TextInputAction.send,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: AppLabels.of(context).get('chat.write_a_message'),
                      hintStyle: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: const Color(0x80000000),
                      ).copyWith(fontFamilyFallback: const ['NotoColorEmoji']),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 2),
                      filled: false,
                      isDense: true,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ).copyWith(fontFamilyFallback: const ['NotoColorEmoji']),
                    maxLines: null,
                    validator: _model
                        .messageTextFieldTextControllerValidator
                        .asValidator(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                  child: GestureDetector(
                    onTap: () => _showEmojiPicker(context),
                    child: const Icon(
                      Icons.emoji_emotions,
                      color: Color(0x80000000),
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
