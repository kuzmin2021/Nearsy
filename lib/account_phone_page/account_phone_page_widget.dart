import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import 'account_phone_page_model.dart';

export 'account_phone_page_model.dart';

/// Lets a signed-in user add or update their Supabase phone number.
class AccountPhonePageWidget extends StatefulWidget {
  const AccountPhonePageWidget({super.key});

  static String routeName = 'AccountPhonePage';
  static String routePath = '/account-phone';

  @override
  State<AccountPhonePageWidget> createState() => _AccountPhonePageWidgetState();
}

class _AccountPhonePageWidgetState extends State<AccountPhonePageWidget> {
  late AccountPhonePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSaving = false;
  bool _hasRequestedCode = false;
  bool _showInvalidCode = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AccountPhonePageModel());

    final phone = SupaFlow.client.auth.currentUser?.phone ?? currentPhoneNumber;
    _model.phoneFieldTextController ??= TextEditingController(text: phone);
    _model.phone = phone;
    _model.phoneFieldFocusNode ??= FocusNode();
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

  String get _phone => _model.phoneFieldTextController.text.trim();

  Future<void> _handleArrowTap() async {
    if (_isSaving) {
      return;
    }
    if (!_hasRequestedCode) {
      await _sendPhoneCode();
      return;
    }
    await _verifyPhoneCode();
  }

  Future<void> _sendPhoneCode() async {
    final phone = _phone;
    if (!_isValidPhone(phone)) {
      _showSnackBar('account_phone.invalid_phone');
      return;
    }
    if (currentUserUid.isEmpty) {
      _showSnackBar('account_phone.save_error');
      return;
    }

    safeSetState(() {
      _isSaving = true;
      _showInvalidCode = false;
    });
    try {
      await SupaFlow.client.auth.updateUser(UserAttributes(phone: phone));
      if (!mounted) {
        return;
      }
      _clearCode();
      safeSetState(() {
        _hasRequestedCode = true;
      });
      if (_model.codeFieldFocusNodes.isNotEmpty) {
        _model.codeFieldFocusNodes.first.requestFocus();
      }
      _showSnackBar('account_phone.code_sent');
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showSnackBar('account_phone.save_error');
    } finally {
      if (mounted) {
        safeSetState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _verifyPhoneCode() async {
    final phone = _phone;
    final code = _currentCode();
    if (!_isValidPhone(phone)) {
      _showSnackBar('account_phone.invalid_phone');
      return;
    }
    if (code.length != 6) {
      _showSnackBar('account_phone.enter_code');
      return;
    }

    safeSetState(() {
      _isSaving = true;
      _showInvalidCode = false;
    });
    try {
      await SupaFlow.client.auth.verifyOTP(
        phone: phone,
        token: code,
        type: OtpType.phoneChange,
      );
      await currentUser?.refreshUser();
      if (!mounted) {
        return;
      }
      _showSnackBar('account_phone.phone_updated');
      context.pop();
    } catch (_) {
      if (!mounted) {
        return;
      }
      safeSetState(() {
        _showInvalidCode = true;
      });
    } finally {
      if (mounted) {
        safeSetState(() {
          _isSaving = false;
        });
      }
    }
  }

  bool _isValidPhone(String phone) {
    final phonePattern = RegExp(r'^\+[0-9]{7,15}$');
    return phonePattern.hasMatch(phone);
  }

  String _currentCode() {
    _model.code = _model.codeFieldTextControllers
        .map((controller) => controller.text)
        .join();
    return _model.code ?? '';
  }

  void _clearCode() {
    for (final controller in _model.codeFieldTextControllers) {
      controller.clear();
    }
    _model.code = '';
  }

  void _setCodeFromString(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    for (var i = 0; i < _model.codeFieldTextControllers.length; i++) {
      final next = i < digits.length ? digits[i] : '';
      final controller = _model.codeFieldTextControllers[i];
      if (controller.text != next) {
        controller.text = next;
        controller.selection = TextSelection.collapsed(offset: next.length);
      }
    }
    _model.code = digits.length > 6 ? digits.substring(0, 6) : digits;
    final nextFocusIndex = (_model.code?.length ?? 0).clamp(0, 5).toInt();
    _model.codeFieldFocusNodes[nextFocusIndex].requestFocus();
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
            padding: const EdgeInsetsDirectional.fromSTEB(
              43.0,
              29.0,
              42.0,
              28.0,
            ),
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
                          AppLabels.of(context).get('account_phone.title'),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: _titleStyle(context),
                        ),
                      ),
                    ].divide(const SizedBox(width: 20.0)),
                  ),
                  const SizedBox(height: 53.0),
                  SizedBox(
                    width: 273.0,
                    height: 38.0,
                    child: TextFormField(
                      controller: _model.phoneFieldTextController,
                      focusNode: _model.phoneFieldFocusNode,
                      onChanged: (value) {
                        _model.phone = value;
                        if (_showInvalidCode) {
                          safeSetState(() {
                            _showInvalidCode = false;
                          });
                        }
                      },
                      enabled: !_isSaving,
                      obscureText: false,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                      ],
                      decoration: InputDecoration(
                        hintText: AppLabels.of(context).get(
                          'account_phone.phone_number',
                        ),
                        hintStyle: _bodyStyle(
                          context,
                          color: FloterTheme.of(context)
                              .primaryText
                              .withValues(alpha: 0.5),
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
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FloterTheme.of(context)
                                .primaryText
                                .withValues(alpha: 0.5),
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        filled: true,
                        fillColor: FloterTheme.of(context).primaryBackground,
                      ),
                      style: _bodyStyle(context).override(fontSize: 16.0),
                      maxLines: 1,
                      onFieldSubmitted: (_) async {
                        await _sendPhoneCode();
                      },
                      validator:
                          _model.phoneFieldTextControllerValidator.asValidator(
                        context,
                      ),
                    ),
                  ),
                  const SizedBox(height: 158.0),
                  SizedBox(
                    width: 302.0,
                    child: Text(
                      AppLabels.of(context).get('account_phone.code_label'),
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
                                await _handleArrowTap();
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
                  const SizedBox(height: 14.0),
                  Text(
                    AppLabels.of(context).get('account_phone.code_hint'),
                    style: _bodyStyle(context).override(fontSize: 16.0),
                  ),
                  const SizedBox(height: 20.0),
                  if (_showInvalidCode)
                    SizedBox(
                      width: 270.0,
                      child: Text(
                        AppLabels.of(context).get(
                          'account_phone.invalid_code',
                        ),
                        style: _bodyStyle(
                          context,
                          color: const Color(0xFFF4442E),
                        ).override(fontSize: 16.0),
                      ),
                    ),
                  const SizedBox(height: 39.0),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: _isSaving
                        ? null
                        : () async {
                            await _sendPhoneCode();
                          },
                    child: Text(
                      AppLabels.of(context).get('account_phone.resend_code'),
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
        enabled: !_isSaving,
        obscureText: false,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
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
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: FloterTheme.of(context).primaryText.withValues(alpha: 0.5),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(6.0),
          ),
          filled: true,
          fillColor: FloterTheme.of(context).primaryBackground,
        ),
        style: _buttonStyle(context),
        onChanged: (value) {
          if (value.length > 1) {
            _setCodeFromString(value);
            return;
          }
          _currentCode();
          if (_showInvalidCode) {
            safeSetState(() {
              _showInvalidCode = false;
            });
          }
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
