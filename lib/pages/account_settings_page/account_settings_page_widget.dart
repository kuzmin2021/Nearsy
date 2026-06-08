import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'account_settings_page_model.dart';
export 'account_settings_page_model.dart';

/// Manages notification settings, feedback, hiding, and logout.
class AccountSettingsPageWidget extends StatefulWidget {
  const AccountSettingsPageWidget({super.key});

  static String routeName = 'AccountSettingsPage';
  static String routePath = '/settings';

  @override
  State<AccountSettingsPageWidget> createState() =>
      _AccountSettingsPageWidgetState();
}

class _AccountSettingsPageWidgetState extends State<AccountSettingsPageWidget> {
  late AccountSettingsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _memberId = '';
  String _accountEmail = '';
  String _accountPhone = '';
  bool _isLoadingAccountSettings = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AccountSettingsPageModel());
    _loadAccountSettings();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  TextStyle _bodyStyle(BuildContext context, {Color? color}) =>
      FloterTheme.of(context).bodyMedium.override(
            font: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontStyle: FloterTheme.of(context).bodyMedium.fontStyle,
            ),
            color: color ?? FloterTheme.of(context).primaryText,
            fontSize: 16.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w400,
            fontStyle: FloterTheme.of(context).bodyMedium.fontStyle,
            lineHeight: 1.2,
          );

  TextStyle _sectionStyle(BuildContext context) =>
      FloterTheme.of(context).titleSmall.override(
            font: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontStyle: FloterTheme.of(context).titleSmall.fontStyle,
            ),
            color: FloterTheme.of(context).primaryText,
            fontSize: 16.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w700,
            fontStyle: FloterTheme.of(context).titleSmall.fontStyle,
            lineHeight: 1.2,
          );

  String _displayValue(String value) => value.trim().isNotEmpty ? value : '-';

  Future<void> _loadAccountSettings() async {
    final userId = currentUserUid;
    if (userId.isEmpty) {
      safeSetState(() {
        _isLoadingAccountSettings = false;
      });
      return;
    }

    final authUser = SupaFlow.client.auth.currentUser;
    try {
      final profile = await SupaFlow.client
          .from('profiles')
          .select('id, email')
          .eq('user_id', userId)
          .maybeSingle();
      final settings = await SupaFlow.client
          .from('user_settings')
          .select(
            'push_matches, push_messages, push_liked_you, email_matches, email_messages, email_liked_you',
          )
          .eq('user_id', userId)
          .maybeSingle();

      if (!mounted) {
        return;
      }

      safeSetState(() {
        _memberId = (profile?['id'] ?? '').toString();
        _accountEmail =
            (authUser?.email ?? profile?['email'] ?? currentUserEmail)
                .toString();
        _accountPhone = (authUser?.phone ?? currentPhoneNumber).toString();

        _model.pushMatches =
            (settings?['push_matches'] as bool?) ?? _model.pushMatches;
        _model.pushMessages =
            (settings?['push_messages'] as bool?) ?? _model.pushMessages;
        _model.pushLikedYou =
            (settings?['push_liked_you'] as bool?) ?? _model.pushLikedYou;
        _model.emailMatches =
            (settings?['email_matches'] as bool?) ?? _model.emailMatches;
        _model.emailMessages =
            (settings?['email_messages'] as bool?) ?? _model.emailMessages;
        _model.emailLikedYou =
            (settings?['email_liked_you'] as bool?) ?? _model.emailLikedYou;

        _model.pushMatchesToggleValue = _model.pushMatches;
        _model.pushMessagesToggleValue = _model.pushMessages;
        _model.pushLikedYouToggleValue = _model.pushLikedYou;
        _model.emailMatchesToggleValue = _model.emailMatches;
        _model.emailMessagesToggleValue = _model.emailMessages;
        _model.emailLikedYouToggleValue = _model.emailLikedYou;
        _isLoadingAccountSettings = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      safeSetState(() {
        _accountEmail = currentUserEmail;
        _accountPhone = currentPhoneNumber;
        _isLoadingAccountSettings = false;
      });
    }
  }

  Future<void> _updateUserSetting(String column, bool value) async {
    final userId = currentUserUid;
    if (userId.isEmpty) {
      return;
    }

    try {
      await SupaFlow.client.from('user_settings').upsert({
        'user_id': userId,
        column: value,
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save account setting.'),
          duration: Duration(milliseconds: 3000),
        ),
      );
    }
  }

  Widget _header(BuildContext context) {
    return Row(
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
        Text(
          AppLabels.of(context).get(
            'account_settings.title' /* Account Settings */,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: FloterTheme.of(context).titleMedium.override(
                font: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontStyle: FloterTheme.of(context).titleMedium.fontStyle,
                ),
                color: FloterTheme.of(context).primaryText,
                fontSize: 20.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w700,
                fontStyle: FloterTheme.of(context).titleMedium.fontStyle,
                lineHeight: 1.2,
              ),
        ),
      ].divide(const SizedBox(width: 15.0)),
    );
  }

  Widget _accountRow(
    BuildContext context, {
    required String label,
    required String value,
    String? actionLabel,
    Future<void> Function()? onActionTap,
  }) {
    return SizedBox(
      height: 32.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              value.isEmpty ? label : '$label: $value',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _bodyStyle(context),
            ),
          ),
          if (actionLabel != null)
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: onActionTap == null
                  ? null
                  : () async {
                      await onActionTap();
                    },
              child: Container(
                width: 72.0,
                height: 32.0,
                alignment: const AlignmentDirectional(1.0, 0.0),
                child: Text(
                  actionLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _bodyStyle(
                    context,
                    color: FloterTheme.of(context).primary,
                  ),
                ),
              ),
            ),
        ].divide(const SizedBox(width: 10.0)),
      ),
    );
  }

  Widget _textActionRow(
    BuildContext context, {
    required String label,
    required Future<void> Function() onTap,
    double height = 32.0,
  }) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        await onTap();
      },
      child: Container(
        height: height,
        alignment: const AlignmentDirectional(-1.0, 0.0),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _bodyStyle(
            context,
            color: FloterTheme.of(context).primary,
          ),
        ),
      ),
    );
  }

  Widget _checkboxRow(
    BuildContext context, {
    required bool value,
    required ValueChanged<bool> onChanged,
    required String label,
    bool enabled = true,
  }) {
    return SizedBox(
      height: 32.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 28.0,
            height: 32.0,
            child: Theme(
              data: ThemeData(
                checkboxTheme: CheckboxThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                unselectedWidgetColor: FloterTheme.of(context).secondaryText,
              ),
              child: Checkbox(
                value: value,
                onChanged: (newValue) {
                  if (!enabled) {
                    return;
                  }
                  if (newValue == null) {
                    return;
                  }
                  onChanged(newValue);
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                side: (FloterTheme.of(context).secondaryText != null)
                    ? BorderSide(
                        width: 2,
                        color: FloterTheme.of(context).secondaryText!,
                      )
                    : null,
                activeColor: FloterTheme.of(context).primary,
                checkColor: FloterTheme.of(context).primaryBackground,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _bodyStyle(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    FTAppState().profileIsOnboarded = false;
    safeSetState(() {});
    GoRouter.of(context).prepareAuthEvent();
    await authManager.signOut();
    GoRouter.of(context).clearRedirectLocation();

    context.goNamedAuth(AuthPageWidget.routeName, context.mounted);
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
              24.0,
              43.0,
              42.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _header(context),
                  const SizedBox(height: 18.0),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 11.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _accountRow(
                          context,
                          label: AppLabels.of(context).get(
                            'account_settings.member_id' /* Member ID */,
                          ),
                          value: _displayValue(_memberId),
                        ),
                        _accountRow(
                          context,
                          label: AppLabels.of(context).get(
                            'account_settings.email' /* Email */,
                          ),
                          value: _displayValue(_accountEmail),
                          actionLabel: AppLabels.of(context).get(
                            'account_settings.edit_email' /* Edit */,
                          ),
                          onActionTap: () async {
                            context.pushNamed(AccountEmailPageWidget.routeName);
                          },
                        ),
                        _accountRow(
                          context,
                          label: AppLabels.of(context).get(
                            'account_settings.phone' /* Phone */,
                          ),
                          value: _displayValue(_accountPhone),
                          actionLabel: AppLabels.of(context).get(
                            'account_settings.edit_phone' /* Edit */,
                          ),

                        ),
                        _accountRow(
                          context,
                          label: AppLabels.of(context).get(
                            'account_settings.password' /* Password */,
                          ),
                          value: '********',
                          actionLabel: AppLabels.of(context).get(
                            'account_settings.edit_password' /* Edit */,
                          ),
                          onActionTap: () async {
                            context.pushNamed(
                              UpdatePasswordPageWidget.routeName,
                            );
                          },
                        ),
                        _accountRow(
                          context,
                          label: AppLabels.of(context).get(
                            'account_settings.two_factor_authentication' /* Two-factor authentication */,
                          ),
                          value: '',
                          actionLabel: AppLabels.of(context).get(
                            'account_settings.manage' /* Manage */,
                          ),
                          onActionTap: () async {
                            context.pushNamed(
                              TwoFactorAuthPageWidget.routeName,
                            );
                          },
                        ),
                        const SizedBox(height: 30.0),
                        Text(
                          AppLabels.of(context).get(
                            'account_settings.notifications' /* Notifications */,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _sectionStyle(context),
                        ),
                        const SizedBox(height: 12.0),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 6.0),
                          child: Text(
                            AppLabels.of(context).get(
                              'account_settings.push_notifications' /* Push Notifications */,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _sectionStyle(context),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        _checkboxRow(
                          context,
                          value: _model.pushMatchesToggleValue ??=
                              _model.pushMatches!,
                          label: AppLabels.of(context).get(
                            'account_settings.matches' /* Matches */,
                          ),
                          enabled: !_isLoadingAccountSettings,
                          onChanged: (newValue) {
                            safeSetState(() {
                              _model.pushMatchesToggleValue = newValue;
                              _model.pushMatches = newValue;
                            });
                            _updateUserSetting('push_matches', newValue);
                          },
                        ),
                        _checkboxRow(
                          context,
                          value: _model.pushMessagesToggleValue ??=
                              _model.pushMessages!,
                          label: AppLabels.of(context).get(
                            'account_settings.messages' /* Messages */,
                          ),
                          enabled: !_isLoadingAccountSettings,
                          onChanged: (newValue) {
                            safeSetState(() {
                              _model.pushMessagesToggleValue = newValue;
                              _model.pushMessages = newValue;
                            });
                            _updateUserSetting('push_messages', newValue);
                          },
                        ),
                        _checkboxRow(
                          context,
                          value: _model.pushLikedYouToggleValue ??=
                              _model.pushLikedYou!,
                          label: AppLabels.of(context).get(
                            'account_settings.liked_you' /* Liked you */,
                          ),
                          enabled: !_isLoadingAccountSettings,
                          onChanged: (newValue) {
                            safeSetState(() {
                              _model.pushLikedYouToggleValue = newValue;
                              _model.pushLikedYou = newValue;
                            });
                            _updateUserSetting('push_liked_you', newValue);
                          },
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 6.0),
                          child: Text(
                            AppLabels.of(context).get(
                              'account_settings.email_notifications' /* Email Notifications */,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: _sectionStyle(context),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        _checkboxRow(
                          context,
                          value: _model.emailMatchesToggleValue ??=
                              _model.emailMatches!,
                          label: AppLabels.of(context).get(
                            'account_settings.matches_email' /* Matches */,
                          ),
                          enabled: !_isLoadingAccountSettings,
                          onChanged: (newValue) {
                            safeSetState(() {
                              _model.emailMatchesToggleValue = newValue;
                              _model.emailMatches = newValue;
                            });
                            _updateUserSetting('email_matches', newValue);
                          },
                        ),
                        _checkboxRow(
                          context,
                          value: _model.emailMessagesToggleValue ??=
                              _model.emailMessages!,
                          label: AppLabels.of(context).get(
                            'account_settings.messages_email' /* Messages */,
                          ),
                          enabled: !_isLoadingAccountSettings,
                          onChanged: (newValue) {
                            safeSetState(() {
                              _model.emailMessagesToggleValue = newValue;
                              _model.emailMessages = newValue;
                            });
                            _updateUserSetting('email_messages', newValue);
                          },
                        ),
                        _checkboxRow(
                          context,
                          value: _model.emailLikedYouToggleValue ??=
                              _model.emailLikedYou!,
                          label: AppLabels.of(context).get(
                            'account_settings.liked_you_email' /* Liked you */,
                          ),
                          enabled: !_isLoadingAccountSettings,
                          onChanged: (newValue) {
                            safeSetState(() {
                              _model.emailLikedYouToggleValue = newValue;
                              _model.emailLikedYou = newValue;
                            });
                            _updateUserSetting('email_liked_you', newValue);
                          },
                        ),
                        const SizedBox(height: 38.0),
                        _textActionRow(
                          context,
                          label: AppLabels.of(context).get(
                            'account_settings.feedback' /* Feedback */,
                          ),
                          onTap: () async {
                            context.pushNamed(ContactUsPageWidget.routeName);
                          },
                        ),
                        _textActionRow(
                          context,
                          label: AppLabels.of(context).get(
                            'account_settings.hide_account' /* Hide account */,
                          ),
                          onTap: () async {
                            context.pushNamed(HideAccountPageWidget.routeName);
                          },
                        ),
                        _textActionRow(
                          context,
                          label: AppLabels.of(context).get(
                            'account_settings.delete_account' /* Delete account */,
                          ),
                          onTap: () async {
                            context
                                .pushNamed(DeleteAccountPageWidget.routeName);
                          },
                        ),
                        const SizedBox(height: 22.0),
                        _textActionRow(
                          context,
                          label: AppLabels.of(context).get(
                            'account_settings.log_out' /* Log out */,
                          ),
                          onTap: () async {
                            await _signOut(context);
                          },
                        ),
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
