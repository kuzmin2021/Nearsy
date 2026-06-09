import 'package:flutter/material.dart';

import '/floter/floter_util.dart';
import 'chat_preferences_page_widget.dart' show ChatPreferencesPageWidget;

class ChatPreferencesPageModel extends FloterModel<ChatPreferencesPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for ChatTopicsField widget.
  FocusNode? chatTopicsFieldFocusNode;
  TextEditingController? chatTopicsFieldTextController;
  String? Function(BuildContext, String?)?
      chatTopicsFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    chatTopicsFieldFocusNode?.dispose();
    chatTopicsFieldTextController?.dispose();
  }
}
