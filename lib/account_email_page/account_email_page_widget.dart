import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import 'account_email_page_model.dart';

export 'account_email_page_model.dart';

/// Lets a signed-in user add or update their Supabase email address.
class AccountEmailPageWidget extends StatefulWidget {
  const AccountEmailPageWidget({super.key});

  static String routeName = 'AccountEmailPage';
  static String routePath = '/account-email';

  @override
  State<AccountEmailPageWidget> createState() => _AccountEmailPageWidgetState();
}

class _AccountEmailPageWidgetState extends State<AccountEmailPageWidget> {
  late AccountEmailPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AccountEmailPageModel());

    _model.emailFieldTextController ??=
        TextEditingController(text: currentUserEmail);
    _model.email = currentUserEmail;
    _model.emailFieldFocusNode ??= FocusNode();
    if (_model.codeFieldTextControllers.isEmpty) {
      for (var i = 0; i < 6; i++) {
        _model.codeFieldTextControllers.add(TextEditingController());
        _model.codeFieldFocusNodes.add(FocusNode());
      }
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  TextStyle _titleStyle(BuildContext context) =>
      FloterTheme.of(context).titleLarge.override(
            font: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontStyle: FloterTheme.of(context).titleLarge.fontStyle,
            ),
            color: FloterTheme.of(context).primaryText,
            fontSize: 24.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w700,
            fontStyle: FloterTheme.of(context).titleLarge.fontStyle,
            lineHeight: 1.2,
          );

  TextStyle _bodyStyle(BuildContext context, {Color? color}) =>
      FloterTheme.of(context).bodyMedium.override(
            font: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontStyle: FloterTheme.of(context).bodyMedium.fontStyle,
            ),
            color: color ?? FloterTheme.of(context).primaryText,
            fontSize: 14.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w400,
            fontStyle: FloterTheme.of(context).bodyMedium.fontStyle,
            lineHeight: 1.2,
          );

  TextStyle _buttonStyle(BuildContext context) =>
      FloterTheme.of(context).bodyMedium.override(
            font: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontStyle: FloterTheme.of(context).bodyMedium.fontStyle,
            ),
            color: FloterTheme.of(context).primaryText,
            fontSize: 16.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w500,
            fontStyle: FloterTheme.of(context).bodyMedium.fontStyle,
          );

  Future<void> _sendEmailConfirmation() async {
    if (_isSaving) {
      return;
    }

    final email = _model.emailFieldTextController.text.trim();
    if (!_isValidEmail(email)) {
      _showSnackBar('account_email.invalid_email');
      return;
    }
    if (currentUserUid.isEmpty) {
      _showSnackBar('account_email.save_error');
      return;
    }

    safeSetState(() {
      _isSaving = true;
    });
    try {
      await SupaFlow.client.auth.updateUser(UserAttributes(email: email));
      if (!mounted) {
        return;
      }
      _showSnackBar('account_email.confirmation_sent');
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showSnackBar('account_email.save_error');
    } finally {
      if (mounted) {
        safeSetState(() {
          _isSaving = false;
        });
      }
    }
  }

  bool _isValidEmail(String email) {
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailPattern.hasMatch(email);
  }

  void _updateCodeValue() {
    _model.code = _model.codeFieldTextControllers
        .map((controller) => controller.text)
        .join();
  }

  void _showSnackBar(String labelKey) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLabels.of(context).get(labelKey)),
        duration: const Duration(milliseconds: 3000),
      ),
    );
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
            padding:
                const EdgeInsetsDirectional.fromSTEB(43.0, 29.0, 42.0, 28.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      Expanded(
                        child: Text(
                          AppLabels.of(context).get(
                            'account_email.title',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _titleStyle(context),
                        ),
                      ),
                    ].divide(const SizedBox(width: 20.0)),
                  ),
                  const SizedBox(height: 56.0),
                  Text(
                    AppLabels.of(context).get('account_email.your_email'),
                    style: _bodyStyle(context).override(fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    width: 273.0,
                    height: 38.0,
                    child: TextFormField(
                      controller: _model.emailFieldTextController,
                      focusNode: _model.emailFieldFocusNode,
                      onChanged: (value) {
                        _model.email = value;
                      },
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: AppLabels.of(context).get(
                          'account_email.email_address',
                        ),
                        hintStyle: _bodyStyle(
                          context,
                          color: FloterTheme.of(context)
                              .primaryText
                              .withOpacity(0.5),
                        ),
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(
                          16.0,
                          0.0,
                          16.0,
                          0.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FloterTheme.of(context).primaryText,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FloterTheme.of(context).primaryText,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red.shade700,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red.shade700,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        filled: true,
                        fillColor: FloterTheme.of(context).primaryBackground,
                      ),
                      style: _bodyStyle(context).override(fontSize: 16.0),
                      maxLines: 1,
                      onFieldSubmitted: (_) async {
                        await _sendEmailConfirmation();
                      },
                      validator:
                          _model.emailFieldTextControllerValidator.asValidator(
                        context,
                      ),
                    ),
                  ),
                  const SizedBox(height: 145.0),
                  SizedBox(
                    width: 302.0,
                    child: Text(
                      AppLabels.of(context).get('account_email.code_label'),
                      style: _bodyStyle(context).override(fontSize: 16.0),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...List.generate(
                        6,
                        (index) => _codeBox(context, index),
                      ).divide(const SizedBox(width: 10.0)),
                      const SizedBox(width: 15.0),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: _isSaving
                            ? null
                            : () async {
                                await _sendEmailConfirmation();
                              },
                        child: Opacity(
                          opacity: _isSaving ? 0.6 : 1.0,
                          child: Container(
                            width: 42.0,
                            height: 42.0,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.arrow_forward,
                              color: FloterTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 94.0),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: _isSaving
                        ? null
                        : () async {
                            await _sendEmailConfirmation();
                          },
                    child: Text(
                      AppLabels.of(context).get('account_email.resend_code'),
                      style: _bodyStyle(
                        context,
                        color: const Color(0xFF9400D3),
                      ).override(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _codeBox(BuildContext context, int index) {
    return SizedBox(
      width: 31.0,
      height: 46.0,
      child: TextFormField(
        controller: _model.codeFieldTextControllers[index],
        focusNode: _model.codeFieldFocusNodes[index],
        obscureText: false,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FloterTheme.of(context).primaryText,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(6.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FloterTheme.of(context).primaryText,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(6.0),
          ),
          filled: true,
          fillColor: FloterTheme.of(context).primaryBackground,
        ),
        style: _buttonStyle(context),
        onChanged: (value) {
          _updateCodeValue();
          if (value.isNotEmpty && index < 5) {
            _model.codeFieldFocusNodes[index + 1].requestFocus();
          }
          if (value.isEmpty && index > 0) {
            _model.codeFieldFocusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}
