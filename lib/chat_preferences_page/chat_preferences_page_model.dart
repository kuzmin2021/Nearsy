import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import 'dart:ui';
import 'chat_preferences_page_widget.dart' show ChatPreferencesPageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatPreferencesPageModel
    extends FloterModel<ChatPreferencesPageWidget> {
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
