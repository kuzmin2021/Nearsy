import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'search_preferences_page_model.dart';
export 'search_preferences_page_model.dart';

/// Figma search preferences flow for dating filters.
class SearchPreferencesPageWidget extends StatefulWidget {
  const SearchPreferencesPageWidget({super.key});

  static String routeName = 'SearchPreferencesPage';
  static String routePath = '/search-preferences';

  @override
  State<SearchPreferencesPageWidget> createState() =>
      _SearchPreferencesPageWidgetState();
}

class _SearchPreferencesPageWidgetState
    extends State<SearchPreferencesPageWidget> {
  late SearchPreferencesPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SearchPreferencesPageModel());
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
                            'r26bpflk' /* Search Preferences */,
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
                      '1ceobegk' /* Who you want to date: */,
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              value: _model.checkboxValue1 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue1 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'ej9yk57d' /* Women */,
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
                              value: _model.checkboxValue2 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue2 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'dy9g6y15' /* Men */,
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
                              value: _model.checkboxValue3 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue3 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'a9s8whut' /* Other */,
                            ),
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ].divide(SizedBox(height: 8.0)),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        FTLocalizations.of(context).getText(
                          '3e8iu5qv' /* Age: */,
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
                              fontStyle: FloterTheme.of(context)
                                  .titleSmall
                                  .fontStyle,
                            ),
                      ),
                      Text(
                        FTLocalizations.of(context).getText(
                          'qxhimjcb' /* Between 20 and 50 */,
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
                              fontStyle: FloterTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ].divide(SizedBox(height: 4.0)),
                  ),
                  Container(
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: FloterTheme.of(context).alternate,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: FloterTheme.of(context).primary,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: FloterTheme.of(context).alternate,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        FTLocalizations.of(context).getText(
                          'qx2es48d' /* Search radius: */,
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
                              fontStyle: FloterTheme.of(context)
                                  .titleSmall
                                  .fontStyle,
                            ),
                      ),
                      Text(
                        FTLocalizations.of(context).getText(
                          'ozz4jru3' /* Up to 161 kilometres away */,
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
                              fontStyle: FloterTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ].divide(SizedBox(height: 4.0)),
                  ),
                  Container(
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: FloterTheme.of(context).alternate,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: FloterTheme.of(context).primary,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: FloterTheme.of(context).alternate,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    FTLocalizations.of(context).getText(
                      'zct3y2e7' /* Languages they know: */,
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              value: _model.checkboxValue4 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue4 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'rold44c7' /* Afar */,
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
                              value: _model.checkboxValue5 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue5 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              '0cps7xi2' /* Afrikaans */,
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
                              value: _model.checkboxValue6 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue6 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'gw9mgb1k' /* Albanian */,
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
                              value: _model.checkboxValue7 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue7 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              '4o1b7hdw' /* Amharic */,
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
                              value: _model.checkboxValue8 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue8 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'bl0kfji0' /* Arabic */,
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
                              value: _model.checkboxValue9 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue9 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'k95dn1le' /* Armenian */,
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
                              value: _model.checkboxValue10 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue10 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'ryyp6qis' /* Bengali */,
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
                              value: _model.checkboxValue11 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue11 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'ajfq1v6c' /* Catalan */,
                            ),
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ].divide(SizedBox(height: 8.0)),
                  ),
                  Text(
                    FTLocalizations.of(context).getText(
                      'opjm711h' /* What are they looking for? */,
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              value: _model.checkboxValue12 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue12 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              '6vfvx1lg' /* Something serious */,
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
                              value: _model.checkboxValue13 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue13 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              '261ma4hv' /* Just dating */,
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
                              value: _model.checkboxValue14 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue14 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'j7rnlwhp' /* Just fun */,
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
                              value: _model.checkboxValue15 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue15 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'pkln3ugj' /* Open to anything */,
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
                              value: _model.checkboxValue16 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue16 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              '4qwv2rlu' /* Not sure */,
                            ),
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ].divide(SizedBox(height: 8.0)),
                  ),
                  Text(
                    FTLocalizations.of(context).getText(
                      'bvwkn5e4' /* What are their beliefs? */,
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              value: _model.checkboxValue17 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue17 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'dwstzpd5' /* Agnostic */,
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
                              value: _model.checkboxValue18 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue18 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'b070wcti' /* Atheist */,
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
                              value: _model.checkboxValue19 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue19 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'do33iuna' /* Buddhist */,
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
                              value: _model.checkboxValue20 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue20 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'z6wm40k5' /* Christian */,
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
                              value: _model.checkboxValue21 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue21 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'thois5wg' /* Jewish */,
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
                              value: _model.checkboxValue22 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue22 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'q8p0cvld' /* Muslim */,
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
                              value: _model.checkboxValue23 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue23 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              '1rb5ysd5' /* Other */,
                            ),
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ].divide(SizedBox(height: 8.0)),
                  ),
                  Text(
                    FTLocalizations.of(context).getText(
                      'f4in38tx' /* Do they exercise? */,
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              value: _model.checkboxValue24 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue24 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              '5svn0y8u' /* Regularly */,
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
                              value: _model.checkboxValue25 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue25 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'y12tt6lp' /* Occasionally */,
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
                              value: _model.checkboxValue26 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue26 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'tk25c1vl' /* Rarely */,
                            ),
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ].divide(SizedBox(height: 8.0)),
                  ),
                  Text(
                    FTLocalizations.of(context).getText(
                      'bh4cd9kz' /* Do they drink? */,
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              value: _model.checkboxValue27 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue27 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              '133llaz7' /* Yes */,
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
                              value: _model.checkboxValue28 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue28 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              '7meo207v' /* Occasionally */,
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
                              value: _model.checkboxValue29 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue29 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'sbyyyril' /* Rarely */,
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
                              value: _model.checkboxValue30 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue30 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              '4u2f7jk4' /* No */,
                            ),
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ].divide(SizedBox(height: 8.0)),
                  ),
                  Text(
                    FTLocalizations.of(context).getText(
                      'qg5g2soy' /* Do they smoke? */,
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              value: _model.checkboxValue31 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue31 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              '4fbc0b1p' /* Yes */,
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
                              value: _model.checkboxValue32 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue32 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'wpnpxctk' /* Sometimes */,
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
                              value: _model.checkboxValue33 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue33 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'hihnvmcy' /* No */,
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
                              value: _model.checkboxValue34 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue34 = newValue!);
                              },
                              side:
                                  (FloterTheme.of(context).secondaryText !=
                                          null)
                                      ? BorderSide(
                                          width: 2,
                                          color: FloterTheme.of(context)
                                              .secondaryText!,
                                        )
                                      : null,
                              activeColor: FloterTheme.of(context).primary,
                              checkColor: FloterTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                          Container(
                            width: 8.0,
                          ),
                          Text(
                            FTLocalizations.of(context).getText(
                              'z9mkeadz' /* Trying to quit */,
                            ),
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ].divide(SizedBox(height: 8.0)),
                  ),
                  FTButtonWidget(
                    onPressed: () async {
                      context.pushNamed(
                          NearbySearchPreferencesPageWidget.routeName);
                    },
                    text: FTLocalizations.of(context).getText(
                      'wwihxowg' /* Nearby visibility */,
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
                  FTButtonWidget(
                    onPressed: () async {
                      context.pop();
                    },
                    text: FTLocalizations.of(context).getText(
                      '5ru3ofbe' /* Apply filters */,
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
