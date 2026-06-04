import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'email_auth_page_model.dart';
export 'email_auth_page_model.dart';

/// Email sign-in and registration flow.
class EmailAuthPageWidget extends StatefulWidget {
  const EmailAuthPageWidget({super.key});

  static String routeName = 'EmailAuthPage';
  static String routePath = '/auth/email';

  @override
  State<EmailAuthPageWidget> createState() => _EmailAuthPageWidgetState();
}

class _EmailAuthPageWidgetState extends State<EmailAuthPageWidget> {
  late EmailAuthPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EmailAuthPageModel());

    _model.emailFieldTextController ??= TextEditingController();
    _model.emailFieldFocusNode ??= FocusNode();

    _model.passwordFieldTextController ??= TextEditingController();
    _model.passwordFieldFocusNode ??= FocusNode();

    _model.confirmPasswordFieldTextController ??= TextEditingController();
    _model.confirmPasswordFieldFocusNode ??= FocusNode();
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
          child: Container(
            width: double.infinity,
            height: 926.0,
            child: Stack(
              alignment: AlignmentDirectional(0.0, 0.0),
              children: [
                Image.asset(
                  'assets/images/start_screen_bg.png',
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
                                    color: FloterTheme.of(context)
                                        .primaryBackground,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: FloterTheme.of(context)
                                        .primaryText,
                                    size: 24.0,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.favorite_border,
                                color: FloterTheme.of(context).primary,
                                size: 46.0,
                              ),
                            ],
                          ),
                          Container(
                            height: 20.0,
                          ),
                          Text(
                            AppLabels.of(context).get(
                              'email_auth.sign_in_with_email' /* Sign in with email */,
                            ),
                            style: FloterTheme.of(context)
                                .headlineSmall
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FloterTheme.of(context)
                                        .headlineSmall
                                        .fontWeight,
                                    fontStyle: FloterTheme.of(context)
                                        .headlineSmall
                                        .fontStyle,
                                  ),
                                  color:
                                      FloterTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FloterTheme.of(context)
                                      .headlineSmall
                                      .fontWeight,
                                  fontStyle: FloterTheme.of(context)
                                      .headlineSmall
                                      .fontStyle,
                                ),
                          ),
                          Text(
                            AppLabels.of(context).get(
                              'email_auth.use_your_email_and_password_or_create_a_new_account' /* Use your email and password, o... */,
                            ),
                            maxLines: 2,
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
                                  color: FloterTheme.of(context)
                                      .secondaryText,
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
                          Container(
                            height: 12.0,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: FTButtonWidget(
                                      onPressed: () async {
                                        _model.emailMode = 'signIn';
                                        safeSetState(() {});
                                      },
                                      text: AppLabels.of(context).get(
                                        'email_auth.sign_in' /* Sign in */,
                                      ),
                                      options: FTButtonOptions(
                                        width: double.infinity,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FloterTheme.of(context)
                                            .primary,
                                        textStyle: TextStyle(
                                          color: FloterTheme.of(context)
                                              .primaryBackground,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: FTButtonWidget(
                                      onPressed: () async {
                                        _model.emailMode = 'register';
                                        safeSetState(() {});
                                      },
                                      text: AppLabels.of(context).get(
                                        'email_auth.register' /* Register */,
                                      ),
                                      options: FTButtonOptions(
                                        width: double.infinity,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: Colors.transparent,
                                        textStyle: TextStyle(
                                          color: FloterTheme.of(context)
                                              .primary,
                                        ),
                                        borderSide: BorderSide(
                                          color: FloterTheme.of(context)
                                              .primary,
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                ].divide(SizedBox(width: 10.0)),
                              ),
                              TextFormField(
                                controller: _model.emailFieldTextController,
                                focusNode: _model.emailFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.emailFieldTextController',
                                  Duration(milliseconds: 2000),
                                  () async {
                                    _model.email =
                                        _model.emailFieldTextController.text;
                                    safeSetState(() {});
                                  },
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText:
                                      AppLabels.of(context).get(
                                    'email_auth.email_address' /* Email address */,
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
                                    Icons.mail,
                                  ),
                                ),
                                style: TextStyle(),
                                maxLines: null,
                                keyboardType: TextInputType.emailAddress,
                                validator: _model
                                    .emailFieldTextControllerValidator
                                    .asValidator(context),
                              ),
                              TextFormField(
                                controller: _model.passwordFieldTextController,
                                focusNode: _model.passwordFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.passwordFieldTextController',
                                  Duration(milliseconds: 2000),
                                  () async {
                                    _model.password =
                                        _model.passwordFieldTextController.text;
                                    safeSetState(() {});
                                  },
                                ),
                                obscureText: !_model.passwordFieldVisibility,
                                decoration: InputDecoration(
                                  labelText:
                                      AppLabels.of(context).get(
                                    'email_auth.password' /* Password */,
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
                                      safeSetState(() =>
                                          _model.passwordFieldVisibility =
                                              !_model.passwordFieldVisibility);
                                    },
                                    focusNode: FocusNode(skipTraversal: true),
                                    child: Icon(
                                      _model.passwordFieldVisibility
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                style: TextStyle(),
                                validator: _model
                                    .passwordFieldTextControllerValidator
                                    .asValidator(context),
                              ),
                              if (_model.emailMode == 'register')
                                TextFormField(
                                  controller:
                                      _model.confirmPasswordFieldTextController,
                                  focusNode:
                                      _model.confirmPasswordFieldFocusNode,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.confirmPasswordFieldTextController',
                                    Duration(milliseconds: 2000),
                                    () async {
                                      _model.confirmPassword = _model
                                          .confirmPasswordFieldTextController
                                          .text;
                                      safeSetState(() {});
                                    },
                                  ),
                                  obscureText:
                                      !_model.confirmPasswordFieldVisibility,
                                  decoration: InputDecoration(
                                    labelText:
                                        AppLabels.of(context).get(
                                      'email_auth.repeat_password' /* Repeat password */,
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
                                                .confirmPasswordFieldVisibility =
                                            !_model
                                                .confirmPasswordFieldVisibility);
                                      },
                                      focusNode: FocusNode(skipTraversal: true),
                                      child: Icon(
                                        _model.confirmPasswordFieldVisibility
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(),
                                  validator: _model
                                      .confirmPasswordFieldTextControllerValidator
                                      .asValidator(context),
                                ),
                              if (_model.emailMode == 'signIn')
                                FTButtonWidget(
                                  onPressed: () async {
                                    Function() _navigate = () {};
                                    if (_model.email == '') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Enter your email address.',
                                            style: TextStyle(),
                                          ),
                                          duration:
                                              Duration(milliseconds: 4000),
                                        ),
                                      );
                                    } else {
                                      if (_model.password == '') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Enter your password.',
                                              style: TextStyle(),
                                            ),
                                            duration:
                                                Duration(milliseconds: 4000),
                                          ),
                                        );
                                      } else {
                                        FTAppState().profileIsOnboarded = false;
                                        safeSetState(() {});
                                        GoRouter.of(context).prepareAuthEvent();

                                        final user =
                                            await authManager.signInWithEmail(
                                          context,
                                          _model.email!,
                                          _model.password!,
                                        );
                                        if (user == null) {
                                          return;
                                        }

                                        _navigate = () => context.goNamedAuth(
                                            ProfilePageWidget.routeName,
                                            context.mounted);
                                      }
                                    }

                                    _navigate();
                                  },
                                  text: AppLabels.of(context).get(
                                    'email_auth.continue_button' /* Continue */,
                                  ),
                                  options: FTButtonOptions(
                                    width: double.infinity,
                                    height: 48.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: Color(0xFFC2A7FF),
                                    textStyle: TextStyle(
                                      color: FloterTheme.of(context)
                                          .primaryText,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              if (_model.emailMode == 'register')
                                FTButtonWidget(
                                  onPressed: () async {
                                    Function() _navigate = () {};
                                    if (_model.email == '') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Enter your email address.',
                                            style: TextStyle(),
                                          ),
                                          duration:
                                              Duration(milliseconds: 4000),
                                        ),
                                      );
                                    } else {
                                      if (_model.password == '') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Enter your password.',
                                              style: TextStyle(),
                                            ),
                                            duration:
                                                Duration(milliseconds: 4000),
                                          ),
                                        );
                                      } else {
                                        if (_model.confirmPassword == '') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Confirm your password.',
                                                style: TextStyle(),
                                              ),
                                              duration:
                                                  Duration(milliseconds: 4000),
                                            ),
                                          );
                                        } else {
                                          if (_model.password ==
                                              _model.confirmPassword) {
                                            FTAppState().profileIsOnboarded =
                                                false;
                                            safeSetState(() {});
                                            GoRouter.of(context)
                                                .prepareAuthEvent();
                                            if (_model.password! !=
                                                _model.confirmPassword!) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Passwords don\'t match!',
                                                  ),
                                                ),
                                              );
                                              return;
                                            }

                                            final user = await authManager
                                                .createAccountWithEmail(
                                              context,
                                              _model.email!,
                                              _model.password!,
                                            );
                                            if (user == null) {
                                              return;
                                            }

                                            _navigate = () =>
                                                context.goNamedAuth(
                                                    ProfilePageWidget.routeName,
                                                    context.mounted);
                                            _model.createdSignupProfile =
                                                await ProfilesTable().insert({
                                              'user_id': currentUserUid,
                                              'email': currentUserEmail,
                                              'display_name': '',
                                              'catchphrase': '',
                                              'is_onboarded': false,
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Passwords do not match.',
                                                  style: TextStyle(),
                                                ),
                                                duration: Duration(
                                                    milliseconds: 4000),
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    }

                                    _navigate();

                                    safeSetState(() {});
                                  },
                                  text: AppLabels.of(context).get(
                                    'email_auth.create_account' /* Create account */,
                                  ),
                                  options: FTButtonOptions(
                                    width: double.infinity,
                                    height: 48.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: Color(0xFFC2A7FF),
                                    textStyle: TextStyle(
                                      color: FloterTheme.of(context)
                                          .primaryText,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              if (_model.emailMode == 'signIn')
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    context.pushNamed(
                                        ResetPasswordPageWidget.routeName);
                                  },
                                  child: Container(
                                    height: 48.0,
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Text(
                                      AppLabels.of(context).get(
                                        'email_auth.forgot_password' /* Forgot password? */,
                                      ),
                                      textAlign: TextAlign.center,
                                      style: FloterTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FloterTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FloterTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: FloterTheme.of(context)
                                                .primary,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FloterTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FloterTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                ),
                            ].divide(SizedBox(height: 14.0)),
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
