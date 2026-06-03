import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'chat_preferences_page_model.dart';
export 'chat_preferences_page_model.dart';

/// Figma chat availability preferences screen.
class ChatPreferencesPageWidget extends StatefulWidget {
  const ChatPreferencesPageWidget({super.key});

  static String routeName = 'ChatPreferencesPage';
  static String routePath = '/chat-preferences';

  @override
  State<ChatPreferencesPageWidget> createState() =>
      _ChatPreferencesPageWidgetState();
}

class _ChatPreferencesPageWidgetState extends State<ChatPreferencesPageWidget> {
  late ChatPreferencesPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatPreferencesPageModel());

    _model.chatTopicsFieldTextController ??= TextEditingController();
    _model.chatTopicsFieldFocusNode ??= FocusNode();
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
            padding: EdgeInsetsDirectional.fromSTEB(24.0, 44.0, 24.0, 28.0),
            child: SingleChildScrollView(
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
                        buttonSize: 40.0,
                        fillColor:
                            FloterTheme.of(context).primaryBackground,
                        icon: Icon(
                          Icons.arrow_back,
                          color: FloterTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          context.pop();
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          FTLocalizations.of(context).getText(
                            'hke77tzj' /* Chat Preferences */,
                          ),
                          maxLines: 2,
                          style:
                              FloterTheme.of(context).titleLarge.override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FloterTheme.of(context)
                                          .titleLarge
                                          .fontWeight,
                                      fontStyle: FloterTheme.of(context)
                                          .titleLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FloterTheme.of(context)
                                        .titleLarge
                                        .fontWeight,
                                    fontStyle: FloterTheme.of(context)
                                        .titleLarge
                                        .fontStyle,
                                  ),
                        ),
                      ),
                    ].divide(SizedBox(width: 12.0)),
                  ),
                  Text(
                    FTLocalizations.of(context).getText(
                      'oblqk4dv' /* Choose who can message you. Yo... */,
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
                          letterSpacing: 0.0,
                          fontWeight: FloterTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FloterTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  Text(
                    FTLocalizations.of(context).getText(
                      'run936hm' /* Availability modes: */,
                    ),
                    style: FloterTheme.of(context).titleSmall.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FloterTheme.of(context)
                                .titleSmall
                                .fontWeight,
                            fontStyle: FloterTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FloterTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FloterTheme.of(context).titleSmall.fontStyle,
                        ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 54.0,
                              height: 54.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(27.0),
                                border: Border.all(
                                  color: FloterTheme.of(context).alternate,
                                  width: 4.0,
                                ),
                              ),
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Icon(
                                Icons.do_not_disturb_on,
                                color:
                                    FloterTheme.of(context).secondaryText,
                                size: 24.0,
                              ),
                            ),
                            Text(
                              FTLocalizations.of(context).getText(
                                '9ueqeejc' /* Unavailable */,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              style: FloterTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FloterTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FloterTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FloterTheme.of(context)
                                        .bodySmall
                                        .fontWeight,
                                    fontStyle: FloterTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ].divide(SizedBox(height: 6.0)),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 54.0,
                              height: 54.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(27.0),
                                border: Border.all(
                                  color: FloterTheme.of(context).primary,
                                  width: 4.0,
                                ),
                              ),
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Icon(
                                Icons.group,
                                color: FloterTheme.of(context).secondary,
                                size: 24.0,
                              ),
                            ),
                            Text(
                              FTLocalizations.of(context).getText(
                                '9je3gcf7' /* Matched users only */,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              style: FloterTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FloterTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FloterTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FloterTheme.of(context)
                                        .bodySmall
                                        .fontWeight,
                                    fontStyle: FloterTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ].divide(SizedBox(height: 6.0)),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 54.0,
                              height: 54.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(27.0),
                                border: Border.all(
                                  color: FloterTheme.of(context).alternate,
                                  width: 4.0,
                                ),
                              ),
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Icon(
                                Icons.public,
                                color:
                                    FloterTheme.of(context).secondaryText,
                                size: 24.0,
                              ),
                            ),
                            Text(
                              FTLocalizations.of(context).getText(
                                'rynvhts0' /* Available */,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              style: FloterTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FloterTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FloterTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FloterTheme.of(context)
                                        .bodySmall
                                        .fontWeight,
                                    fontStyle: FloterTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ].divide(SizedBox(height: 6.0)),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    FTLocalizations.of(context).getText(
                      '41ha6dgj' /* Stuff I could talk about for h... */,
                    ),
                    style: FloterTheme.of(context).titleSmall.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FloterTheme.of(context)
                                .titleSmall
                                .fontWeight,
                            fontStyle: FloterTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FloterTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FloterTheme.of(context).titleSmall.fontStyle,
                        ),
                  ),
                  TextFormField(
                    controller: _model.chatTopicsFieldTextController,
                    focusNode: _model.chatTopicsFieldFocusNode,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: FTLocalizations.of(context).getText(
                        'tvxcs529' /* Obscure sci-fi films with depr... */,
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
                    maxLines: 5,
                    validator: _model.chatTopicsFieldTextControllerValidator
                        .asValidator(context),
                  ),
                  FTButtonWidget(
                    onPressed: () async {
                      context.pop();
                    },
                    text: FTLocalizations.of(context).getText(
                      'hz3lhlw8' /* Save chat preferences */,
                    ),
                    options: FTButtonOptions(
                      width: double.infinity,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FloterTheme.of(context).primary,
                      textStyle: TextStyle(
                        color: FloterTheme.of(context).primaryBackground,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ].divide(SizedBox(height: 16.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
