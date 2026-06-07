import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import '/index.dart';
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

    _model.emailFieldTextController ??=
        TextEditingController(text: 'ak@test.ru');
    _model.emailFieldFocusNode ??= FocusNode();
    _model.email = 'ak@test.ru';

    _model.passwordFieldTextController ??=
        TextEditingController(text: 'Test1234!');
    _model.passwordFieldFocusNode ??= FocusNode();
    _model.password = 'Test1234!';

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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: double.infinity,
                height: constraints.maxHeight,
                child: Stack(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/start_screen_bg.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0x66FFFFFF),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 80.0,
                      left: 42.0,
                      right: 42.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                                    color: Color(0xFFC9B0FF),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
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
                                  color: FloterTheme.of(context).primaryText,
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
                            style: FloterTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FloterTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FloterTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: FloterTheme.of(context).secondaryText,
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
                        ].divide(SizedBox(height: 16.0)),
                      ),
                    ),
                    Positioned(
                      left: 42.0,
                      right: 42.0,
                      bottom: constraints.maxHeight * 0.10,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: constraints.maxHeight * 0.75,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 38.0,
                                child: TextFormField(
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
                                    hintText: AppLabels.of(context).get(
                                      'email_auth.email_address' /* Email address */,
                                    ),
                                    hintStyle: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 1,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _model
                                      .emailFieldTextControllerValidator
                                      .asValidator(context),
                                ),
                              ),
                              SizedBox(
                                height: 38.0,
                                child: TextFormField(
                                  controller:
                                      _model.passwordFieldTextController,
                                  focusNode: _model.passwordFieldFocusNode,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.passwordFieldTextController',
                                    Duration(milliseconds: 2000),
                                    () async {
                                      _model.password = _model
                                          .passwordFieldTextController.text;
                                      safeSetState(() {});
                                    },
                                  ),
                                  obscureText: !_model.passwordFieldVisibility,
                                  decoration: InputDecoration(
                                    hintText: AppLabels.of(context).get(
                                      'email_auth.password' /* Password */,
                                    ),
                                    hintStyle: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                    filled: true,
                                    fillColor: Colors.white,
                                    suffixIconConstraints: BoxConstraints(
                                      minWidth: 42.0,
                                      minHeight: 38.0,
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: () async {
                                        safeSetState(() => _model
                                                .passwordFieldVisibility =
                                            !_model.passwordFieldVisibility);
                                      },
                                      focusNode: FocusNode(skipTraversal: true),
                                      child: Icon(
                                        _model.passwordFieldVisibility
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 1,
                                  validator: _model
                                      .passwordFieldTextControllerValidator
                                      .asValidator(context),
                                ),
                              ),
                              if (_model.emailMode == 'register')
                                SizedBox(
                                  height: 38.0,
                                  child: TextFormField(
                                    controller: _model
                                        .confirmPasswordFieldTextController,
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
                                      hintText: AppLabels.of(context).get(
                                        'email_auth.repeat_password' /* Repeat password */,
                                      ),
                                      hintStyle: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              16.0, 0.0, 16.0, 0.0),
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIconConstraints: BoxConstraints(
                                        minWidth: 42.0,
                                        minHeight: 38.0,
                                      ),
                                      suffixIcon: InkWell(
                                        onTap: () async {
                                          safeSetState(() => _model
                                                  .confirmPasswordFieldVisibility =
                                              !_model
                                                  .confirmPasswordFieldVisibility);
                                        },
                                        focusNode:
                                            FocusNode(skipTraversal: true),
                                        child: Icon(
                                          _model.confirmPasswordFieldVisibility
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    style: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 1,
                                    validator: _model
                                        .confirmPasswordFieldTextControllerValidator
                                        .asValidator(context),
                                  ),
                                ),
                              if (_model.emailMode == 'signIn')
                                FTButtonWidget(
                                  onPressed: () async {
                                    Function() _navigate = () {};
                                    final email = _model
                                        .emailFieldTextController.text
                                        .trim();
                                    final password =
                                        _model.passwordFieldTextController.text;
                                    _model.email = email;
                                    _model.password = password;
                                    if (email.isEmpty) {
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
                                      if (password.isEmpty) {
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
                                          email,
                                          password,
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
                                  iconData: Icons.arrow_forward,
                                  options: FTButtonOptions(
                                    width: double.infinity,
                                    height: 48.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        4.0, 0.0, 0.0, 0.0),
                                    color: Color(0xFFC9B0FF),
                                    textStyle: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    iconSize: 20.0,
                                    iconColor: Colors.black,
                                    iconAlignment: IconAlignment.end,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              if (_model.emailMode == 'register')
                                FTButtonWidget(
                                  onPressed: () async {
                                    Function() _navigate = () {};
                                    final email = _model
                                        .emailFieldTextController.text
                                        .trim();
                                    final password =
                                        _model.passwordFieldTextController.text;
                                    final confirmPassword = _model
                                        .confirmPasswordFieldTextController
                                        .text;
                                    _model.email = email;
                                    _model.password = password;
                                    _model.confirmPassword = confirmPassword;
                                    if (email.isEmpty) {
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
                                      if (password.isEmpty) {
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
                                        if (confirmPassword.isEmpty) {
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
                                          if (password == confirmPassword) {
                                            FTAppState().profileIsOnboarded =
                                                false;
                                            safeSetState(() {});
                                            GoRouter.of(context)
                                                .prepareAuthEvent();
                                            if (password != confirmPassword) {
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
                                              email,
                                              password,
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
                                  iconData: Icons.arrow_forward,
                                  options: FTButtonOptions(
                                    width: double.infinity,
                                    height: 48.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        4.0, 0.0, 0.0, 0.0),
                                    color: Color(0xFFC9B0FF),
                                    textStyle: GoogleFonts.inter(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    iconSize: 20.0,
                                    iconColor: Colors.black,
                                    iconAlignment: IconAlignment.end,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              if (_model.emailMode == 'signIn')
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
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
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Text(
                                          AppLabels.of(context).get(
                                            'email_auth.forgot_password' /* Forgot password? */,
                                          ),
                                          textAlign: TextAlign.start,
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
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        _model.emailMode = 'register';
                                        safeSetState(() {});
                                      },
                                      child: Container(
                                        height: 48.0,
                                        alignment:
                                            AlignmentDirectional.centerEnd,
                                        child: Text(
                                          AppLabels.of(context).get(
                                            'email_auth.register' /* Register */,
                                          ),
                                          textAlign: TextAlign.end,
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
                                  ],
                                ),
                              if (_model.emailMode == 'register')
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    _model.emailMode = 'signIn';
                                    safeSetState(() {});
                                  },
                                  child: Container(
                                    height: 48.0,
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Text(
                                      AppLabels.of(context).get(
                                        'email_auth.sign_in' /* Sign in */,
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
                                              fontStyle: FloterTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                            ),
                                            color:
                                                FloterTheme.of(context).primary,
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
                            ].divide(SizedBox(height: 14.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
