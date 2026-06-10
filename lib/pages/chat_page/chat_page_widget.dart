import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'chat_page_model.dart';
import '/models/chat_models.dart';
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
          child: CachedNetworkImage(
            fadeInDuration: Duration.zero,
            fadeOutDuration: Duration.zero,
            imageUrl: _model.partnerAvatar ?? '',
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              color: FloterTheme.of(context).secondaryBackground,
              child: const Icon(Icons.person, size: 24),
            ),
            errorWidget: (_, __, ___) => Container(
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
                                  ),
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: CachedNetworkImage(
                              imageUrl: msg.photoUrl!,
                              width: 200,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => const SizedBox(
                                width: 200,
                                height: 150,
                                child: Center(
                                    child: CircularProgressIndicator()),
                              ),
                              errorWidget: (_, __, ___) => Container(
                                width: 200,
                                height: 100,
                                color: theme.secondaryBackground,
                                child: const Icon(Icons.broken_image),
                              ),
                            ),
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
          ),
        ),
      ],
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Container(
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
              obscureText: false,
              decoration: InputDecoration(
                hintText: AppLabels.of(context).get('chat.write_a_message'),
                hintStyle: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: const Color(0x80000000),
                ),
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
              ),
              maxLines: null,
              validator: _model
                  .messageTextFieldTextControllerValidator
                  .asValidator(context),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
            child: FloterIconButton(
              borderRadius: 24,
              buttonSize: 34,
              fillColor: const Color(0xFF9400D3),
              icon: const Icon(
                Icons.arrow_upward_rounded,
                color: Colors.white,
                size: 18,
              ),
              onPressed: () async {
                await _model.sendMessage();
                safeSetState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
