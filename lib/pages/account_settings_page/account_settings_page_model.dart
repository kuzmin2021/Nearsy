import '/floter/floter_util.dart';
import '/index.dart';
import 'account_settings_page_widget.dart' show AccountSettingsPageWidget;
import 'package:flutter/material.dart';

class AccountSettingsPageModel extends FloterModel<AccountSettingsPageWidget> {
  ///  Local state fields for this page.

  String? feedbackMessage = '';

  String? reportUserId = '';

  String? reportDetails = '';

  bool? pushMatches = true;

  bool? pushMessages = true;

  bool? pushLikedYou = true;

  bool? emailMatches = false;

  bool? emailMessages = false;

  bool? emailLikedYou = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for PushMatchesToggle widget.
  bool? pushMatchesToggleValue;
  // State field(s) for PushMessagesToggle widget.
  bool? pushMessagesToggleValue;
  // State field(s) for PushLikedYouToggle widget.
  bool? pushLikedYouToggleValue;
  // State field(s) for EmailMatchesToggle widget.
  bool? emailMatchesToggleValue;
  // State field(s) for EmailMessagesToggle widget.
  bool? emailMessagesToggleValue;
  // State field(s) for EmailLikedYouToggle widget.
  bool? emailLikedYouToggleValue;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
