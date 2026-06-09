import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_page_model.dart';
export 'chat_page_model.dart';

/// Displays and sends messages in one conversation.
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

    _model.messageTextFieldTextController ??= TextEditingController();
    _model.messageTextFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FloterTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20.0, 29.0, 20.0, 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FloterIconButton(
                      borderRadius: 8.0,
                      buttonSize: 48.0,
                      fillColor: FloterTheme.of(context).primaryBackground,
                      icon: Icon(
                        Icons.arrow_back,
                        color: FloterTheme.of(context).primaryText,
                        size: 32.0,
                      ),
                      onPressed: () async {
                        context.pop();
                      },
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32.0),
                      child: CachedNetworkImage(
                        fadeInDuration: Duration(milliseconds: 0),
                        fadeOutDuration: Duration(milliseconds: 0),
                        imageUrl:
                            'https://www.figma.com/api/mcp/asset/20dbdff4-2d1c-4bf5-849e-179720053bfe',
                        width: 64.0,
                        height: 64.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      AppLabels.of(context).get(
                        'skip' /* Kirill, 38 */,
                      ),
                      style: FloterTheme.of(context).titleMedium.override(
                            font: GoogleFonts.interTight(
                              fontWeight: FloterTheme.of(context)
                                  .titleMedium
                                  .fontWeight,
                              fontStyle:
                                  FloterTheme.of(context).titleMedium.fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight:
                                FloterTheme.of(context).titleMedium.fontWeight,
                            fontStyle:
                                FloterTheme.of(context).titleMedium.fontStyle,
                          ),
                    ),
                  ].divide(SizedBox(width: 12.0)),
                ),
                Container(
                  height: 8.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: FloterTheme.of(context).primary,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 8.0, 16.0, 8.0),
                        child: Text(
                          AppLabels.of(context).get(
                            'chat.chyokak' /* Chyokak? */,
                          ),
                          style: FloterTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FloterTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FloterTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                color:
                                    FloterTheme.of(context).primaryBackground,
                                letterSpacing: 0.0,
                                fontWeight: FloterTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FloterTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: FloterTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 8.0, 16.0, 8.0),
                        child: Text(
                          AppLabels.of(context).get(
                            'chat.normur' /* Normur */,
                          ),
                          style: FloterTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FloterTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FloterTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                color: FloterTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FloterTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FloterTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  AppLabels.of(context).get(
                    'chat.kirill_is_typing' /* Kirill is typing... */,
                  ),
                  textAlign: TextAlign.center,
                  style: FloterTheme.of(context).bodySmall.override(
                        font: GoogleFonts.inter(
                          fontWeight:
                              FloterTheme.of(context).bodySmall.fontWeight,
                          fontStyle:
                              FloterTheme.of(context).bodySmall.fontStyle,
                        ),
                        color: FloterTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                        fontWeight:
                            FloterTheme.of(context).bodySmall.fontWeight,
                        fontStyle: FloterTheme.of(context).bodySmall.fontStyle,
                      ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _model.messageTextFieldTextController,
                        focusNode: _model.messageTextFieldFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          '_model.messageTextFieldTextController',
                          Duration(milliseconds: 2000),
                          () async {
                            _model.messageText =
                                _model.messageTextFieldTextController.text;
                            safeSetState(() {});
                          },
                        ),
                        onFieldSubmitted: (_) async {
                          _model.messageText = '';
                          safeSetState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Message sent',
                                style: TextStyle(),
                              ),
                              duration: Duration(milliseconds: 4000),
                            ),
                          );
                        },
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: AppLabels.of(context).get(
                            'chat.write_a_message' /* Write a message */,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          filled: true,
                        ),
                        style: TextStyle(),
                        maxLines: null,
                        validator: _model
                            .messageTextFieldTextControllerValidator
                            .asValidator(context),
                      ),
                    ),
                    FloterIconButton(
                      borderRadius: 24.0,
                      buttonSize: 40.0,
                      fillColor: FloterTheme.of(context).primary,
                      icon: Icon(
                        Icons.send,
                        color: FloterTheme.of(context).primaryBackground,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        _model.messageText = '';
                        safeSetState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Message sent',
                              style: TextStyle(),
                            ),
                            duration: Duration(milliseconds: 4000),
                          ),
                        );
                      },
                    ),
                  ].divide(SizedBox(width: 10.0)),
                ),
              ].divide(SizedBox(height: 16.0)),
            ),
          ),
        ),
      ),
    );
  }
}
