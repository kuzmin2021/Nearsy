import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_page_model.dart';
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
            padding: const EdgeInsetsDirectional.fromSTEB(20, 29, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context, theme),
                const SizedBox(height: 16),
                Expanded(
                  child: _model.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _model.messages.isEmpty
                          ? Center(
                              child: Text(
                                AppLabels.of(context).get('chat.no_messages'),
                                style: theme.bodyMedium,
                              ),
                            )
                          : _buildMessageList(context, theme),
                ),
                _buildInputBar(context, theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, FloterTheme theme) {
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
          fillColor: theme.primaryBackground,
          icon: Icon(
            Icons.arrow_back,
            color: theme.primaryText,
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
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              color: theme.secondaryBackground,
              child: const Icon(Icons.person, size: 32),
            ),
            errorWidget: (_, __, ___) => Container(
              color: theme.secondaryBackground,
              child: const Icon(Icons.person, size: 32),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          nameParts.join(', '),
          style: theme.titleMedium.override(
            font: GoogleFonts.interTight(
              fontWeight: theme.titleMedium.fontWeight,
              fontStyle: theme.titleMedium.fontStyle,
            ),
            letterSpacing: 0,
            fontWeight: theme.titleMedium.fontWeight,
            fontStyle: theme.titleMedium.fontStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageList(BuildContext context, FloterTheme theme) {
    return ListView.builder(
      controller: _model.scrollController,
      reverse: false,
      itemCount: _model.messages.length,
      itemBuilder: (context, index) {
        final msg = _model.messages[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment:
                msg.isOwn ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                constraints:
                    BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                decoration: BoxDecoration(
                  color: msg.isOwn
                      ? theme.primary
                      : theme.secondaryBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (msg.body.isNotEmpty)
                        Text(
                          msg.body,
                          style: theme.bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: theme.bodyMedium.fontWeight,
                              fontStyle: theme.bodyMedium.fontStyle,
                            ),
                            color: msg.isOwn
                                ? theme.primaryBackground
                                : theme.primaryText,
                            letterSpacing: 0,
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

  Widget _buildInputBar(BuildContext context, FloterTheme theme) {
    return Row(
      mainAxisSize: MainAxisSize.max,
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
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0x00000000), width: 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0x00000000), width: 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0x00000000), width: 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0x00000000), width: 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              filled: true,
            ),
            style: const TextStyle(),
            maxLines: null,
            validator: _model
                .messageTextFieldTextControllerValidator
                .asValidator(context),
          ),
        ),
        const SizedBox(width: 10),
        FloterIconButton(
          borderRadius: 24,
          buttonSize: 40,
          fillColor: theme.primary,
          icon: Icon(
            Icons.send,
            color: theme.primaryBackground,
            size: 24,
          ),
          onPressed: () async {
            await _model.sendMessage();
            safeSetState(() {});
          },
        ),
      ],
    );
  }
}
