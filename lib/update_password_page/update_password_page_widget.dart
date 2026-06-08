import '/auth/supabase_auth/auth_util.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'update_password_page_model.dart';
export 'update_password_page_model.dart';

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

  bool get _hasInput =>
      (_model.updatePasswordFieldTextController.text.trim().isNotEmpty) &&
      (_model.confirmUpdatePasswordFieldTextController.text.trim().isNotEmpty);

  bool get _passwordsMismatch =>
      _hasInput &&
      _model.updatePasswordFieldTextController.text !=
          _model.confirmUpdatePasswordFieldTextController.text;

  bool get _canSubmit => _hasInput && !_passwordsMismatch;

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

  Future<void> _savePassword() async {
    if (!_canSubmit) {
      safeSetState(() {});
      return;
    }

    final appLabels = AppLabels.of(context);
    final password = _model.updatePasswordFieldTextController.text;

    try {
      await authManager.updatePassword(
        newPassword: password,
        context: context,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            appLabels.get('update_password.password_updated'),
          ),
        ),
      );
      context.safePop();
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            appLabels.get('update_password.save_error'),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLabels = AppLabels.of(context);
    final hasError = _passwordsMismatch;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(43.0, 29.0, 42.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FloterIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 12.0,
                      buttonSize: 48.0,
                      fillColor: FloterTheme.of(context).primaryBackground,
                      icon: Icon(
                        Icons.arrow_back,
                        color: FloterTheme.of(context).primaryText,
                        size: 32.0,
                      ),
                      onPressed: () async {
                        context.safePop();
                      },
                    ),
                    const SizedBox(width: 21.0),
                    Expanded(
                      child: Text(
                        appLabels.get('update_password.title'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.0,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 59.0),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 34.0),
                  child: SizedBox(
                    width: 273.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _PasswordInput(
                          controller: _model.updatePasswordFieldTextController!,
                          focusNode: _model.updatePasswordFieldFocusNode!,
                          hintText: appLabels.get(
                            'update_password.new_password',
                          ),
                          textInputAction: TextInputAction.next,
                          borderColor: Colors.black,
                          onChanged: (value) {
                            _model.password = value;
                            safeSetState(() {});
                          },
                        ),
                        const SizedBox(height: 22.0),
                        _PasswordInput(
                          controller:
                              _model.confirmUpdatePasswordFieldTextController!,
                          focusNode:
                              _model.confirmUpdatePasswordFieldFocusNode!,
                          hintText: appLabels.get(
                            'update_password.repeat_password',
                          ),
                          textInputAction: TextInputAction.done,
                          borderColor: hasError
                              ? FloterTheme.of(context).primary
                              : Colors.black,
                          onChanged: (value) {
                            _model.confirmPassword = value;
                            safeSetState(() {});
                          },
                          onSubmitted: (_) => _savePassword(),
                        ),
                        const SizedBox(height: 14.0),
                        SizedBox(
                          height: 24.0,
                          child: hasError
                              ? Text(
                                  appLabels.get(
                                    'update_password.passwords_do_not_match',
                                  ),
                                  style: GoogleFonts.inter(
                                    color: FloterTheme.of(context).primary,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.0,
                                    height: 1.2,
                                  ),
                                )
                              : null,
                        ),
                        SizedBox(height: hasError ? 20.0 : 17.0),
                        InkWell(
                          borderRadius: BorderRadius.circular(15.0),
                          onTap: _hasInput ? _savePassword : null,
                          child: Container(
                            width: 273.0,
                            height: 48.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _hasInput
                                  ? Colors.white
                                  : const Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(15.0),
                              border: _hasInput
                                  ? Border.all(
                                      color: Colors.black,
                                      width: 0.5,
                                    )
                                  : null,
                            ),
                            child: Text(
                              appLabels.get('update_password.submit_button'),
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.0,
                                height: 1.2,
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
          ),
        ),
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.borderColor,
    required this.onChanged,
    required this.textInputAction,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final Color borderColor;
  final ValueChanged<String> onChanged;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(
        color: borderColor,
        width: 0.5,
      ),
      borderRadius: BorderRadius.circular(15.0),
    );

    return SizedBox(
      height: 38.0,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: true,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        cursorColor: FloterTheme.of(context).primary,
        style: GoogleFonts.inter(
          color: Colors.black,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.0,
          height: 1.2,
        ),
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.0,
            height: 1.2,
          ),
          contentPadding:
              const EdgeInsetsDirectional.fromSTEB(15.0, 9.0, 15.0, 9.0),
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: border,
          focusedErrorBorder: border,
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
