import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'delete_account_page_model.dart';
export 'delete_account_page_model.dart';

/// Figma delete account confirmation screen.
class DeleteAccountPageWidget extends StatefulWidget {
  const DeleteAccountPageWidget({super.key});

  static String routeName = 'DeleteAccountPage';
  static String routePath = '/delete-account';

  @override
  State<DeleteAccountPageWidget> createState() =>
      _DeleteAccountPageWidgetState();
}

class _DeleteAccountPageWidgetState extends State<DeleteAccountPageWidget> {
  late DeleteAccountPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DeleteAccountPageModel());
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
                          AppLabels.of(context).get(
                            'delete_account.title' /* Delete account */,
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
                    AppLabels.of(context).get(
                      'delete_account.label_1' /* This will permanently delete y... */,
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: FloterTheme.of(context).alternate,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppLabels.of(context).get(
                              'delete_account.are_you_sure' /* Are you sure? */,
                            ),
                            style: FloterTheme.of(context)
                                .titleSmall
                                .override(
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
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: FTButtonWidget(
                                  onPressed: () async {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Delete account action is ready for backend wiring',
                                          style: TextStyle(),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                      ),
                                    );
                                    context.pop();
                                  },
                                  text: AppLabels.of(context).get(
                                    'delete_account.absolutely' /* Absolutely */,
                                  ),
                                  options: FTButtonOptions(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color:
                                        FloterTheme.of(context).tertiary,
                                    textStyle: TextStyle(
                                      color: FloterTheme.of(context)
                                          .primaryBackground,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: FTButtonWidget(
                                  onPressed: () async {
                                    context.pop();
                                  },
                                  text: AppLabels.of(context).get(
                                    'delete_account.not_quite' /* Not quite */,
                                  ),
                                  options: FTButtonOptions(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color:
                                        FloterTheme.of(context).alternate,
                                    textStyle: TextStyle(
                                      color: FloterTheme.of(context)
                                          .primaryText,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(width: 10.0)),
                          ),
                        ].divide(SizedBox(height: 12.0)),
                      ),
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
