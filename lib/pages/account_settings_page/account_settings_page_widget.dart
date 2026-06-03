import '/auth/supabase_auth/auth_util.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'account_settings_page_model.dart';
export 'account_settings_page_model.dart';

/// Manages notification settings, feedback, hiding, and logout.
class AccountSettingsPageWidget extends StatefulWidget {
  const AccountSettingsPageWidget({super.key});

  static String routeName = 'AccountSettingsPage';
  static String routePath = '/settings';

  @override
  State<AccountSettingsPageWidget> createState() =>
      _AccountSettingsPageWidgetState();
}

class _AccountSettingsPageWidgetState extends State<AccountSettingsPageWidget> {
  late AccountSettingsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AccountSettingsPageModel());
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
            padding: EdgeInsetsDirectional.fromSTEB(43.0, 24.0, 50.0, 42.0),
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
                        buttonSize: 48.0,
                        fillColor:
                            FloterTheme.of(context).primaryBackground,
                        icon: Icon(
                          Icons.arrow_back,
                          color: FloterTheme.of(context).primaryText,
                          size: 32.0,
                        ),
                        onPressed: () async {
                          context.pop();
                        },
                      ),
                      Text(
                        FTLocalizations.of(context).getText(
                          'g8akwzb1' /* Account Settings */,
                        ),
                        style:
                            FloterTheme.of(context).titleMedium.override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FloterTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FloterTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FloterTheme.of(context)
                                      .titleMedium
                                      .fontWeight,
                                  fontStyle: FloterTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                      ),
                    ].divide(SizedBox(width: 15.0)),
                  ),
                  Container(
                    height: 12.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          FTLocalizations.of(context).getText(
                            '7w151rh4' /* Member ID:  19074217 */,
                          ),
                          maxLines: 1,
                          style:
                              FloterTheme.of(context).bodyMedium.override(
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
                                    fontStyle: FloterTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ].divide(SizedBox(width: 10.0)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          FTLocalizations.of(context).getText(
                            'oco1zpb0' /* Email:  abram@gmail.com */,
                          ),
                          maxLines: 1,
                          style:
                              FloterTheme.of(context).bodyMedium.override(
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
                                    fontStyle: FloterTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        width: 72.0,
                        height: 48.0,
                        alignment: AlignmentDirectional(1.0, 0.0),
                        child: Text(
                          FTLocalizations.of(context).getText(
                            '0afjx8ko' /* Edit */,
                          ),
                          style:
                              FloterTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FloterTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FloterTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FloterTheme.of(context).primary,
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
                    ].divide(SizedBox(width: 10.0)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          FTLocalizations.of(context).getText(
                            'qgxkprry' /* Phone:  13173849446 */,
                          ),
                          maxLines: 1,
                          style:
                              FloterTheme.of(context).bodyMedium.override(
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
                                    fontStyle: FloterTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        width: 72.0,
                        height: 48.0,
                        alignment: AlignmentDirectional(1.0, 0.0),
                        child: Text(
                          FTLocalizations.of(context).getText(
                            '9tpm8z1d' /* Edit */,
                          ),
                          style:
                              FloterTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FloterTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FloterTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FloterTheme.of(context).primary,
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
                    ].divide(SizedBox(width: 10.0)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          FTLocalizations.of(context).getText(
                            'qncwd9eh' /* Password:  ******** */,
                          ),
                          maxLines: 1,
                          style:
                              FloterTheme.of(context).bodyMedium.override(
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
                                    fontStyle: FloterTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed(UpdatePasswordPageWidget.routeName);
                        },
                        child: Container(
                          width: 72.0,
                          height: 48.0,
                          alignment: AlignmentDirectional(1.0, 0.0),
                          child: Text(
                            FTLocalizations.of(context).getText(
                              'b15egb2c' /* Edit */,
                            ),
                            style: FloterTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FloterTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FloterTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: FloterTheme.of(context).primary,
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
                    ].divide(SizedBox(width: 10.0)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          FTLocalizations.of(context).getText(
                            'u2lvgvo6' /* Email authentication */,
                          ),
                          maxLines: 1,
                          style:
                              FloterTheme.of(context).bodyMedium.override(
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
                                    fontStyle: FloterTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed(EmailAuthPageWidget.routeName);
                        },
                        child: Container(
                          width: 72.0,
                          height: 48.0,
                          alignment: AlignmentDirectional(1.0, 0.0),
                          child: Text(
                            FTLocalizations.of(context).getText(
                              'gu67jn9n' /* Manage */,
                            ),
                            style: FloterTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FloterTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FloterTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: FloterTheme.of(context).primary,
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
                    ].divide(SizedBox(width: 10.0)),
                  ),
                  Container(
                    height: 17.0,
                  ),
                  Text(
                    FTLocalizations.of(context).getText(
                      'yw0s6dhx' /* Notifications */,
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
                  Text(
                    FTLocalizations.of(context).getText(
                      '8vqwop22' /*   Push Notifications */,
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
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Theme(
                        data: ThemeData(
                          checkboxTheme: CheckboxThemeData(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          unselectedWidgetColor:
                              FloterTheme.of(context).secondaryText,
                        ),
                        child: Checkbox(
                          value: _model.pushMatchesToggleValue ??=
                              _model.pushMatches!,
                          onChanged: (newValue) async {
                            safeSetState(() =>
                                _model.pushMatchesToggleValue = newValue!);
                            if (newValue!) {
                              _model.pushMatches =
                                  _model.pushMatchesToggleValue;
                              safeSetState(() {});
                            } else {
                              _model.pushMatches =
                                  _model.pushMatchesToggleValue;
                              safeSetState(() {});
                            }
                          },
                          side: (FloterTheme.of(context).secondaryText !=
                                  null)
                              ? BorderSide(
                                  width: 2,
                                  color: FloterTheme.of(context)
                                      .secondaryText!,
                                )
                              : null,
                          activeColor: FloterTheme.of(context).primary,
                          checkColor:
                              FloterTheme.of(context).primaryBackground,
                        ),
                      ),
                      Container(
                        width: 8.0,
                      ),
                      Text(
                        FTLocalizations.of(context).getText(
                          '9kqemlf5' /* Matches */,
                        ),
                        style: TextStyle(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Theme(
                        data: ThemeData(
                          checkboxTheme: CheckboxThemeData(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          unselectedWidgetColor:
                              FloterTheme.of(context).secondaryText,
                        ),
                        child: Checkbox(
                          value: _model.pushMessagesToggleValue ??=
                              _model.pushMessages!,
                          onChanged: (newValue) async {
                            safeSetState(() =>
                                _model.pushMessagesToggleValue = newValue!);
                            if (newValue!) {
                              _model.pushMessages =
                                  _model.pushMessagesToggleValue;
                              safeSetState(() {});
                            } else {
                              _model.pushMessages =
                                  _model.pushMessagesToggleValue;
                              safeSetState(() {});
                            }
                          },
                          side: (FloterTheme.of(context).secondaryText !=
                                  null)
                              ? BorderSide(
                                  width: 2,
                                  color: FloterTheme.of(context)
                                      .secondaryText!,
                                )
                              : null,
                          activeColor: FloterTheme.of(context).primary,
                          checkColor:
                              FloterTheme.of(context).primaryBackground,
                        ),
                      ),
                      Container(
                        width: 8.0,
                      ),
                      Text(
                        FTLocalizations.of(context).getText(
                          'eq1ydgxg' /* Messages */,
                        ),
                        style: TextStyle(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Theme(
                        data: ThemeData(
                          checkboxTheme: CheckboxThemeData(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          unselectedWidgetColor:
                              FloterTheme.of(context).secondaryText,
                        ),
                        child: Checkbox(
                          value: _model.pushLikedYouToggleValue ??=
                              _model.pushLikedYou!,
                          onChanged: (newValue) async {
                            safeSetState(() =>
                                _model.pushLikedYouToggleValue = newValue!);
                            if (newValue!) {
                              _model.pushLikedYou =
                                  _model.pushLikedYouToggleValue;
                              safeSetState(() {});
                            } else {
                              _model.pushLikedYou =
                                  _model.pushLikedYouToggleValue;
                              safeSetState(() {});
                            }
                          },
                          side: (FloterTheme.of(context).secondaryText !=
                                  null)
                              ? BorderSide(
                                  width: 2,
                                  color: FloterTheme.of(context)
                                      .secondaryText!,
                                )
                              : null,
                          activeColor: FloterTheme.of(context).primary,
                          checkColor:
                              FloterTheme.of(context).primaryBackground,
                        ),
                      ),
                      Container(
                        width: 8.0,
                      ),
                      Text(
                        FTLocalizations.of(context).getText(
                          'gjwnz4hu' /* Liked you */,
                        ),
                        style: TextStyle(),
                      ),
                    ],
                  ),
                  Text(
                    FTLocalizations.of(context).getText(
                      'uxq1n9vz' /*   Email Notifications */,
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
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Theme(
                        data: ThemeData(
                          checkboxTheme: CheckboxThemeData(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          unselectedWidgetColor:
                              FloterTheme.of(context).secondaryText,
                        ),
                        child: Checkbox(
                          value: _model.emailMatchesToggleValue ??=
                              _model.emailMatches!,
                          onChanged: (newValue) async {
                            safeSetState(() =>
                                _model.emailMatchesToggleValue = newValue!);
                            if (newValue!) {
                              _model.emailMatches =
                                  _model.emailMatchesToggleValue;
                              safeSetState(() {});
                            } else {
                              _model.emailMatches =
                                  _model.emailMatchesToggleValue;
                              safeSetState(() {});
                            }
                          },
                          side: (FloterTheme.of(context).secondaryText !=
                                  null)
                              ? BorderSide(
                                  width: 2,
                                  color: FloterTheme.of(context)
                                      .secondaryText!,
                                )
                              : null,
                          activeColor: FloterTheme.of(context).primary,
                          checkColor:
                              FloterTheme.of(context).primaryBackground,
                        ),
                      ),
                      Container(
                        width: 8.0,
                      ),
                      Text(
                        FTLocalizations.of(context).getText(
                          '7y8nzvev' /* Matches */,
                        ),
                        style: TextStyle(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Theme(
                        data: ThemeData(
                          checkboxTheme: CheckboxThemeData(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          unselectedWidgetColor:
                              FloterTheme.of(context).secondaryText,
                        ),
                        child: Checkbox(
                          value: _model.emailMessagesToggleValue ??=
                              _model.emailMessages!,
                          onChanged: (newValue) async {
                            safeSetState(() =>
                                _model.emailMessagesToggleValue = newValue!);
                            if (newValue!) {
                              _model.emailMessages =
                                  _model.emailMessagesToggleValue;
                              safeSetState(() {});
                            } else {
                              _model.emailMessages =
                                  _model.emailMessagesToggleValue;
                              safeSetState(() {});
                            }
                          },
                          side: (FloterTheme.of(context).secondaryText !=
                                  null)
                              ? BorderSide(
                                  width: 2,
                                  color: FloterTheme.of(context)
                                      .secondaryText!,
                                )
                              : null,
                          activeColor: FloterTheme.of(context).primary,
                          checkColor:
                              FloterTheme.of(context).primaryBackground,
                        ),
                      ),
                      Container(
                        width: 8.0,
                      ),
                      Text(
                        FTLocalizations.of(context).getText(
                          'i2lhqaqf' /* Messages */,
                        ),
                        style: TextStyle(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Theme(
                        data: ThemeData(
                          checkboxTheme: CheckboxThemeData(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          unselectedWidgetColor:
                              FloterTheme.of(context).secondaryText,
                        ),
                        child: Checkbox(
                          value: _model.emailLikedYouToggleValue ??=
                              _model.emailLikedYou!,
                          onChanged: (newValue) async {
                            safeSetState(() =>
                                _model.emailLikedYouToggleValue = newValue!);
                            if (newValue!) {
                              _model.emailLikedYou =
                                  _model.emailLikedYouToggleValue;
                              safeSetState(() {});
                            } else {
                              _model.emailLikedYou =
                                  _model.emailLikedYouToggleValue;
                              safeSetState(() {});
                            }
                          },
                          side: (FloterTheme.of(context).secondaryText !=
                                  null)
                              ? BorderSide(
                                  width: 2,
                                  color: FloterTheme.of(context)
                                      .secondaryText!,
                                )
                              : null,
                          activeColor: FloterTheme.of(context).primary,
                          checkColor:
                              FloterTheme.of(context).primaryBackground,
                        ),
                      ),
                      Container(
                        width: 8.0,
                      ),
                      Text(
                        FTLocalizations.of(context).getText(
                          '42l47d1g' /* Liked you */,
                        ),
                        style: TextStyle(),
                      ),
                    ],
                  ),
                  Container(
                    height: 25.0,
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      context.pushNamed(ContactUsPageWidget.routeName);
                    },
                    child: Container(
                      height: 48.0,
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: Text(
                        FTLocalizations.of(context).getText(
                          '2jb9lnvs' /* Feedback */,
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
                              color: FloterTheme.of(context).primary,
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
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      context.pushNamed(HideAccountPageWidget.routeName);
                    },
                    child: Container(
                      height: 48.0,
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: Text(
                        FTLocalizations.of(context).getText(
                          'lkylcqyl' /* Hide account */,
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
                              color: FloterTheme.of(context).primary,
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
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      context.pushNamed(DeleteAccountPageWidget.routeName);
                    },
                    child: Container(
                      height: 48.0,
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: Text(
                        FTLocalizations.of(context).getText(
                          'sea1s8fp' /* Delete account */,
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
                              color: FloterTheme.of(context).primary,
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
                  Container(
                    height: 26.0,
                  ),
                  FTButtonWidget(
                    onPressed: () async {
                      FTAppState().profileIsOnboarded = false;
                      safeSetState(() {});
                      GoRouter.of(context).prepareAuthEvent();
                      await authManager.signOut();
                      GoRouter.of(context).clearRedirectLocation();

                      context.goNamedAuth(
                          AuthPageWidget.routeName, context.mounted);
                    },
                    text: FTLocalizations.of(context).getText(
                      'cfrtj6zl' /* Log out */,
                    ),
                    options: FTButtonOptions(
                      width: double.infinity,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: Colors.transparent,
                      textStyle: TextStyle(
                        color: FloterTheme.of(context).primary,
                      ),
                      borderSide: BorderSide(
                        color: FloterTheme.of(context).primary,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ].divide(SizedBox(height: 13.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
