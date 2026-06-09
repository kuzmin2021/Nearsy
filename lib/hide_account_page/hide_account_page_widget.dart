import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hide_account_page_model.dart';
export 'hide_account_page_model.dart';

/// Figma hide account confirmation screen.
class HideAccountPageWidget extends StatefulWidget {
  const HideAccountPageWidget({super.key});

  static String routeName = 'HideAccountPage';
  static String routePath = '/hide-account';

  @override
  State<HideAccountPageWidget> createState() => _HideAccountPageWidgetState();
}

class _HideAccountPageWidgetState extends State<HideAccountPageWidget> {
  late HideAccountPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isHidden = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HideAccountPageModel());
    _loadHiddenState();
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

  Future<void> _loadHiddenState() async {
    final userId = currentUserUid;
    if (userId.isEmpty) {
      safeSetState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final profiles = await SupaFlow.client
          .from('profiles')
          .select('is_hidden')
          .eq('user_id', userId)
          .limit(1);
      final profile = profiles.isNotEmpty ? profiles.first : null;
      if (!mounted) {
        return;
      }
      safeSetState(() {
        _isHidden = profile?['is_hidden'] == true;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      safeSetState(() {
        _isLoading = false;
      });
      _showSnackBar('hide_account.save_error' /* Could not update account. */);
    }
  }

  Future<void> _toggleHiddenState() async {
    final userId = currentUserUid;
    if (_isLoading || _isSaving) {
      return;
    }
    if (userId.isEmpty) {
      _showSnackBar('hide_account.save_error' /* Could not update account. */);
      return;
    }

    final nextValue = !_isHidden;
    safeSetState(() {
      _isSaving = true;
    });
    try {
      await SupaFlow.client
          .from('profiles')
          .update({'is_hidden': nextValue}).eq('user_id', userId);
      if (!mounted) {
        return;
      }
      safeSetState(() {
        _isHidden = nextValue;
      });
      _showSnackBar(
        nextValue
            ? 'hide_account.hide_success' /* Account hidden. */
            : 'hide_account.unhide_success' /* Account visible. */,
      );
      context.pop();
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showSnackBar('hide_account.save_error' /* Could not update account. */);
    } finally {
      if (mounted) {
        safeSetState(() {
          _isSaving = false;
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

  @override
  Widget build(BuildContext context) {
    final labelKey = _isHidden
        ? 'hide_account.already_hidden_label'
        : 'hide_account.label_1';
    final buttonKey = _isHidden ? 'hide_account.unhide' : 'hide_account.hide';

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
                            'hide_account.title' /* Hide account */,
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
                      labelKey,
                    ),
                    style: _bodyStyle(context),
                  ),
                  const SizedBox(height: 45.0),
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: _isLoading || _isSaving
                          ? null
                          : () async {
                              await _toggleHiddenState();
                            },
                      child: Opacity(
                        opacity: _isLoading || _isSaving ? 0.6 : 1.0,
                        child: Container(
                          width: 231.0,
                          height: 48.0,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9C6FF),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            AppLabels.of(context).get(buttonKey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _buttonStyle(context),
                          ),
                        ),
                      ),
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
