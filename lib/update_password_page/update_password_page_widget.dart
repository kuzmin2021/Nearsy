import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'update_password_page_model.dart';
export 'update_password_page_model.dart';

/// Lets a signed-in user set a new Supabase password.
class UpdatePasswordPageWidget extends StatefulWidget {
  const UpdatePasswordPageWidget({super.key});

  static String routeName = 'UpdatePasswordPage';
  static String routePath = '/auth/update-password';

  @override
  State<UpdatePasswordPageWidget> createState() =>
      _UpdatePasswordPageWidgetState();
}

class _UpdatePasswordPageWidgetState extends State<UpdatePasswordPageWidget> {
  late UpdatePasswordPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UpdatePasswordPageModel());

    _model.updatePasswordFieldTextController ??= TextEditingController();
    _model.updatePasswordFieldFocusNode ??= FocusNode();

    _model.confirmUpdatePasswordFieldTextController ??= TextEditingController();
    _model.confirmUpdatePasswordFieldFocusNode ??= FocusNode();
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            height: 926.0,
            child: Stack(
              alignment: AlignmentDirectional(0.0, 0.0),
              children: [
                CachedNetworkImage(
                  fadeInDuration: Duration(milliseconds: 0),
                  fadeOutDuration: Duration(milliseconds: 0),
                  imageUrl:
                      'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?auto=format&fit=crop&w=900&q=85',
                  width: double.infinity,
                  height: 926.0,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  height: 926.0,
                  decoration: BoxDecoration(
                    color: Color(0x66FFFFFF),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(42.0, 80.0, 42.0, 42.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context.pop();
                                },
                                child: Container(
                                  width: 42.0,
                                  height: 42.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 24.0,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.favorite_border,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 46.0,
                              ),
                            ],
                          ),
                          Container(
                            height: 20.0,
                          ),
                          Text(
                            FFLocalizations.of(context).getText(
                              'vtbhnfbe' /* Update password */,
                            ),
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontStyle,
                                  ),
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .fontStyle,
                                ),
                          ),
                          Text(
                            FFLocalizations.of(context).getText(
                              'k2foskvu' /* Choose a new password for your... */,
                            ),
                            maxLines: 2,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            height: 12.0,
                          ),
                          TextFormField(
                            controller:
                                _model.updatePasswordFieldTextController,
                            focusNode: _model.updatePasswordFieldFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.updatePasswordFieldTextController',
                              Duration(milliseconds: 2000),
                              () async {
                                _model.password = _model
                                    .updatePasswordFieldTextController.text;
                                safeSetState(() {});
                              },
                            ),
                            obscureText: !_model.updatePasswordFieldVisibility,
                            decoration: InputDecoration(
                              labelText: FFLocalizations.of(context).getText(
                                'oiijjlsz' /* New password */,
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
                              prefixIcon: Icon(
                                Icons.lock,
                              ),
                              suffixIcon: InkWell(
                                onTap: () async {
                                  safeSetState(() => _model
                                          .updatePasswordFieldVisibility =
                                      !_model.updatePasswordFieldVisibility);
                                },
                                focusNode: FocusNode(skipTraversal: true),
                                child: Icon(
                                  _model.updatePasswordFieldVisibility
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 22,
                                ),
                              ),
                            ),
                            style: TextStyle(),
                            validator: _model
                                .updatePasswordFieldTextControllerValidator
                                .asValidator(context),
                          ),
                          TextFormField(
                            controller:
                                _model.confirmUpdatePasswordFieldTextController,
                            focusNode:
                                _model.confirmUpdatePasswordFieldFocusNode,
                            onChanged: (_) => EasyDebounce.debounce(
                              '_model.confirmUpdatePasswordFieldTextController',
                              Duration(milliseconds: 2000),
                              () async {
                                _model.confirmPassword = _model
                                    .confirmUpdatePasswordFieldTextController
                                    .text;
                                safeSetState(() {});
                              },
                            ),
                            obscureText:
                                !_model.confirmUpdatePasswordFieldVisibility,
                            decoration: InputDecoration(
                              labelText: FFLocalizations.of(context).getText(
                                'llads8px' /* Repeat password */,
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
                              prefixIcon: Icon(
                                Icons.lock_reset,
                              ),
                              suffixIcon: InkWell(
                                onTap: () async {
                                  safeSetState(() => _model
                                          .confirmUpdatePasswordFieldVisibility =
                                      !_model
                                          .confirmUpdatePasswordFieldVisibility);
                                },
                                focusNode: FocusNode(skipTraversal: true),
                                child: Icon(
                                  _model.confirmUpdatePasswordFieldVisibility
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 22,
                                ),
                              ),
                            ),
                            style: TextStyle(),
                            validator: _model
                                .confirmUpdatePasswordFieldTextControllerValidator
                                .asValidator(context),
                          ),
                          FFButtonWidget(
                            onPressed: () async {
                              Function() _navigate = () {};
                              if (_model.password == '') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Enter your new password.',
                                      style: TextStyle(),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                  ),
                                );
                              } else {
                                if (_model.confirmPassword == '') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Confirm your new password.',
                                        style: TextStyle(),
                                      ),
                                      duration: Duration(milliseconds: 4000),
                                    ),
                                  );
                                } else {
                                  if (_model.password ==
                                      _model.confirmPassword) {
                                    await authManager.updatePassword(
                                      newPassword: _model.password!,
                                      context: context,
                                    );
                                    safeSetState(() {});

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Password updated.',
                                          style: TextStyle(),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Passwords do not match.',
                                          style: TextStyle(),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                      ),
                                    );
                                  }
                                }
                              }

                              _navigate();
                            },
                            text: FFLocalizations.of(context).getText(
                              'myryizr5' /* Update password */,
                            ),
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 48.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).primary,
                              textStyle: TextStyle(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ].divide(SizedBox(height: 16.0)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
