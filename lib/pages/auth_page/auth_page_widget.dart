import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/index.dart';
import '/services/auth_profile_service.dart';
import 'auth_page_model.dart';
export 'auth_page_model.dart';

/// Email sign-in and registration directly on the main auth screen.
class AuthPageWidget extends StatefulWidget {
  const AuthPageWidget({super.key});

  static String routeName = 'AuthPage';
  static String routePath = '/auth';

  @override
  State<AuthPageWidget> createState() => _AuthPageWidgetState();
}

class _AuthPageWidgetState extends State<AuthPageWidget> {
  static const double _authControlHeight = 48.0;

  late AuthPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool get _isRegister => _model.emailMode == 'register';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AuthPageModel());

    _model.emailFieldTextController ??= TextEditingController();
    _model.emailFieldFocusNode ??= FocusNode();

    _model.passwordFieldTextController ??= TextEditingController();
    _model.passwordFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _finishAuth() async {
    await ensureCurrentUserProfile();
    await actions.loadCurrentProfileState();

    if (!mounted) {
      return;
    }
    context.goNamedAuth(ProfilePageWidget.routeName, context.mounted);
  }

  Future<void> _submitEmailAuth() async {
    final labels = AppLabels.of(context);
    final email = _model.emailFieldTextController.text.trim();
    final password = _model.passwordFieldTextController.text;
    _model.email = email;
    _model.password = password;

    if (email.isEmpty) {
      _showMessage(labels.get('email_auth.enter_email'));
      return;
    }
    if (password.isEmpty) {
      _showMessage(labels.get('email_auth.enter_password'));
      return;
    }

    GoRouter.of(context).prepareAuthEvent();
    final user = _isRegister
        ? await authManager.createAccountWithEmail(context, email, password)
        : await authManager.signInWithEmail(context, email, password);
    if (user == null) {
      return;
    }

    await _finishAuth();
  }

  Future<void> _submitSocialAuth(
    Future<BaseAuthUser?> Function(BuildContext) signIn,
  ) async {
    if (_model.socialAuthInProgress) {
      return;
    }
    safeSetState(() => _model.socialAuthInProgress = true);

    await signIn(context);

    if (mounted) {
      safeSetState(() => _model.socialAuthInProgress = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 4000),
      ),
    );
  }

  void _toggleMode() {
    safeSetState(() {
      _model.emailMode = _isRegister ? 'signIn' : 'register';
    });
  }

  @override
  Widget build(BuildContext context) {
    final labels = AppLabels.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FloterTheme.of(context).primaryBackground,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/start_screen_bg.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0x66FFFFFF),
                ),
              ),
            ),
            SafeArea(
              top: true,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: double.infinity,
                    height: constraints.maxHeight,
                    child: Stack(
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      children: [
                        Positioned(
                          top: 68.0,
                          left: 32.0,
                          right: 32.0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/nearsy_logo.png',
                                width: constraints.maxWidth * 0.65,
                                fit: BoxFit.contain,
                              ),
                              Text(
                                labels.get('auth.meet_near_keep_it_easy'),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF000000),
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ].divide(const SizedBox(height: 4.0)),
                          ),
                        ),
                        Positioned(
                          left: 36.0,
                          right: 36.0,
                          bottom: constraints.maxHeight * 0.055,
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: constraints.maxHeight * 0.68,
                                maxWidth: 420.0,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    _AuthTextField(
                                      controller: _model.emailFieldTextController!,
                                      focusNode: _model.emailFieldFocusNode!,
                                      hintText:
                                          labels.get('email_auth.email_address'),
                                      keyboardType: TextInputType.emailAddress,
                                      onChanged: (value) => _model.email = value,
                                    ),
                                    _AuthTextField(
                                      controller:
                                          _model.passwordFieldTextController!,
                                      focusNode: _model.passwordFieldFocusNode!,
                                      hintText: labels.get('email_auth.password'),
                                      obscureText: !_model.passwordFieldVisibility,
                                      onChanged: (value) => _model.password = value,
                                      suffixIcon: InkWell(
                                        onTap: () async {
                                          safeSetState(
                                            () => _model.passwordFieldVisibility =
                                                !_model.passwordFieldVisibility,
                                          );
                                        },
                                        focusNode: FocusNode(skipTraversal: true),
                                        child: Icon(
                                          _model.passwordFieldVisibility
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: const Color(0xFF6A6A6A),
                                          size: 24.0,
                                        ),
                                      ),
                                    ),
                                    _PrimaryAuthButton(
                                      text: _isRegister
                                          ? labels.get('email_auth.create_account')
                                          : labels.get('email_auth.sign_in'),
                                      onTap: _submitEmailAuth,
                                    ),
                                    Text(
                                      _isRegister
                                          ? labels.get('email_auth.or_sign_up_with')
                                          : labels
                                              .get('email_auth.or_sign_in_with'),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF626262),
                                  fontSize: 24.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    _SocialAuthButton(
                                      icon: FontAwesomeIcons.google,
                                      text: labels
                                          .get('email_auth.continue_with_google'),
                                      onTap: () => _submitSocialAuth(
                                        authManager.signInWithGoogle,
                                      ),
                                    ),
                                    _SocialAuthButton(
                                      icon: FontAwesomeIcons.apple,
                                      text: labels
                                          .get('email_auth.continue_with_apple'),
                                      onTap: () => _submitSocialAuth(
                                        authManager.signInWithApple,
                                      ),
                                    ),
                                    if (!_isRegister)
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                            ResetPasswordPageWidget.routeName,
                                          );
                                        },
                                        child: Container(
                                          height: 32.0,
                                          alignment: AlignmentDirectional.center,
                                          child: Text(
                                            labels
                                                .get('email_auth.forgot_password'),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              color:
                                                  FloterTheme.of(context).primary,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    _ModeSwitch(
                                      prefix: _isRegister
                                          ? labels.get(
                                              'email_auth.already_have_account',
                                            )
                                          : labels.get(
                                              'email_auth.dont_have_account',
                                            ),
                                      actionText: _isRegister
                                          ? labels.get('email_auth.sign_in_here')
                                          : labels.get('email_auth.sign_up_here'),
                                      onTap: _toggleMode,
                                    ),
                                  ].divide(const SizedBox(height: 14.0)),
                                ),
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
          ],
        ),
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  const _AuthTextField({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _AuthPageWidgetState._authControlHeight,
      child: Container(
        height: _AuthPageWidgetState._authControlHeight,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          obscureText: obscureText,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            hintStyle: GoogleFonts.inter(
              color: const Color(0xFF6A6A6A),
              fontSize: 20.0,
              height: 1.0,
              fontWeight: FontWeight.w400,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            contentPadding: EdgeInsetsDirectional.fromSTEB(
              18.0,
              2.0,
              suffixIcon == null ? 18.0 : 0.0,
              2.0,
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 52.0,
              minHeight: _AuthPageWidgetState._authControlHeight,
            ),
            suffixIcon: suffixIcon,
          ),
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 20.0,
            height: 1.0,
            fontWeight: FontWeight.w400,
          ),
          strutStyle: const StrutStyle(
            fontSize: 20.0,
            height: 1.0,
            forceStrutHeight: true,
          ),
          maxLines: 1,
          keyboardType: keyboardType,
        ),
      ),
    );
  }
}

class _PrimaryAuthButton extends StatelessWidget {
  const _PrimaryAuthButton({
    required this.text,
    required this.onTap,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        height: _AuthPageWidgetState._authControlHeight,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
          color: const Color(0xFFB000E6),
          borderRadius: BorderRadius.circular(13.0),
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _SocialAuthButton extends StatelessWidget {
  const _SocialAuthButton({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final FaIconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        height: _AuthPageWidgetState._authControlHeight,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 2.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              color: Colors.black,
              size: 24.0,
            ),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ].divide(const SizedBox(width: 12.0)),
        ),
      ),
    );
  }
}

class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch({
    required this.prefix,
    required this.actionText,
    required this.onTap,
  });

  final String prefix;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 34.0),
        alignment: AlignmentDirectional.center,
        child: RichText(
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: [
              TextSpan(
                text: '$prefix  ',
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: actionText,
                style: GoogleFonts.inter(
                  color: FloterTheme.of(context).primary,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
