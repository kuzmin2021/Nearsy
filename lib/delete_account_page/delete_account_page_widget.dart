import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/index.dart';
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
  bool _isDeleting = false;

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

  TextStyle _bodyStyle(BuildContext context) =>
      FloterTheme.of(context).bodyMedium.override(
            font: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontStyle: FloterTheme.of(context).bodyMedium.fontStyle,
            ),
            color: FloterTheme.of(context).primaryText,
            fontSize: 14.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w400,
            fontStyle: FloterTheme.of(context).bodyMedium.fontStyle,
            lineHeight: 1.2,
          );

  TextStyle _buttonStyle(BuildContext context, {Color? color}) =>
      FloterTheme.of(context).bodyMedium.override(
            font: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontStyle: FloterTheme.of(context).bodyMedium.fontStyle,
            ),
            color: color ?? FloterTheme.of(context).primaryText,
            fontSize: 16.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w500,
            fontStyle: FloterTheme.of(context).bodyMedium.fontStyle,
          );

  Future<void> _deleteAccount() async {
    if (_isDeleting) {
      return;
    }
    if (currentUserUid.isEmpty) {
      _showSnackBar('delete_account.delete_error');
      return;
    }

    safeSetState(() {
      _isDeleting = true;
    });
    try {
      await SupaFlow.client.rpc('delete_account_data_v2');
      if (!mounted) {
        return;
      }
      _showSnackBar('delete_account.delete_success');
      FTAppState().profileIsOnboarded = false;
      safeSetState(() {});
      GoRouter.of(context).prepareAuthEvent();
      await authManager.signOut();
      if (!mounted) {
        return;
      }
      GoRouter.of(context).clearRedirectLocation();
      context.goNamedAuth(AuthPageWidget.routeName, context.mounted);
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showSnackBar('delete_account.delete_error');
    } finally {
      if (mounted) {
        safeSetState(() {
          _isDeleting = false;
        });
      }
    }
  }

  void _showSnackBar(String labelKey) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLabels.of(context).get(labelKey)),
        duration: const Duration(milliseconds: 3000),
      ),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback? onTap,
  }) =>
      InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Opacity(
          opacity: onTap == null ? 0.6 : 1.0,
          child: Container(
            height: 48.0,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15.0),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _buttonStyle(context, color: textColor),
            ),
          ),
        ),
      );

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
                        flex: 1,
                        child: Text(
                          AppLabels.of(context).get(
                            'delete_account.title' /* Delete account */,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _titleStyle(context),
                        ),
                      ),
                    ].divide(const SizedBox(width: 20.0)),
                  ),
                  const SizedBox(height: 28.0),
                  Text(
                    AppLabels.of(context).get(
                      'delete_account.label_1' /* This will permanently delete y... */,
                    ),
                    style: _bodyStyle(context),
                  ),
                  const SizedBox(height: 31.0),
                  Center(
                    child: Text(
                      AppLabels.of(context).get(
                        'delete_account.are_you_sure' /* Are you sure? */,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _bodyStyle(context).override(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18.0),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: _actionButton(
                          context,
                          label: AppLabels.of(context).get(
                            'delete_account.absolutely' /* Absolutely */,
                          ),
                          color: const Color(0xFFD9C6FF),
                          textColor: FloterTheme.of(context).primaryText,
                          onTap: _isDeleting
                              ? null
                              : () async {
                                  await _deleteAccount();
                                },
                        ),
                      ),
                      Expanded(
                        child: _actionButton(
                          context,
                          label: AppLabels.of(context).get(
                            'delete_account.not_quite' /* Not quite */,
                          ),
                          color: FloterTheme.of(context).secondaryBackground,
                          textColor: FloterTheme.of(context).primaryText,
                          onTap: _isDeleting
                              ? null
                              : () {
                                  context.pop();
                                },
                        ),
                      ),
                    ].divide(const SizedBox(width: 10.0)),
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
