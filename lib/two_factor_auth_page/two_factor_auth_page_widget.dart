import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/account_email_page/account_email_page_widget.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import 'two_factor_auth_page_model.dart';

export 'two_factor_auth_page_model.dart';

/// Account security screen for two-factor authentication setup.
class TwoFactorAuthPageWidget extends StatefulWidget {
  const TwoFactorAuthPageWidget({super.key});

  static String routeName = 'TwoFactorAuthPage';
  static String routePath = '/two-factor-authentication';

  @override
  State<TwoFactorAuthPageWidget> createState() =>
      _TwoFactorAuthPageWidgetState();
}

class _TwoFactorAuthPageWidgetState extends State<TwoFactorAuthPageWidget> {
  late TwoFactorAuthPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TwoFactorAuthPageModel());
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

  TextStyle _bodyStyle(
    BuildContext context, {
    Color? color,
    FontWeight fontWeight = FontWeight.w400,
  }) =>
      FloterTheme.of(context).bodyMedium.override(
            font: GoogleFonts.inter(
              fontWeight: fontWeight,
              fontStyle: FloterTheme.of(context).bodyMedium.fontStyle,
            ),
            color: color ?? FloterTheme.of(context).primaryText,
            fontSize: 16.0,
            letterSpacing: 0.0,
            fontWeight: fontWeight,
            fontStyle: FloterTheme.of(context).bodyMedium.fontStyle,
            lineHeight: 1.2,
          );

  Future<void> _openEmailSettings() async {
    await context.pushNamed(AccountEmailPageWidget.routeName);
    if (mounted) {
      safeSetState(() {});
    }
  }

  Widget _header(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
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
              'two_factor_auth.title',
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: _titleStyle(context),
          ),
        ),
      ].divide(const SizedBox(width: 20.0)),
    );
  }

  Widget _emailAuthenticationSection(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: _openEmailSettings,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.email_outlined,
                color: FloterTheme.of(context).primaryText,
                size: 28.0,
              ),
              Expanded(
                child: Text(
                  AppLabels.of(context).get(
                    'two_factor_auth.email_title',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _bodyStyle(
                    context,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ].divide(const SizedBox(width: 16.0)),
          ),
          const SizedBox(height: 18.0),
          Text(
            AppLabels.of(context).get(
              'two_factor_auth.email_description',
            ),
            style: _bodyStyle(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final needsVerifiedEmail =
        currentUserEmail.trim().isEmpty || !currentUserEmailVerified;

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
                  _header(context),
                  const SizedBox(height: 37.0),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLabels.of(context).get(
                            'two_factor_auth.intro',
                          ),
                          style: _bodyStyle(context),
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          AppLabels.of(context).get(
                            'two_factor_auth.sms_title',
                          ),
                          style: _bodyStyle(
                            context,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          AppLabels.of(context).get(
                            'two_factor_auth.sms_description',
                          ),
                          style: _bodyStyle(context),
                        ),
                        if (needsVerifiedEmail) ...[
                          const SizedBox(height: 20.0),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: _openEmailSettings,
                            child: Text(
                              AppLabels.of(context).get(
                                'two_factor_auth.email_required',
                              ),
                              style: _bodyStyle(
                                context,
                                color: FloterTheme.of(context).primary,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 48.0),
                        _emailAuthenticationSection(context),
                      ],
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
}
