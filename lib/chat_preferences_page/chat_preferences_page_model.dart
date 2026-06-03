import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'chat_preferences_page_widget.dart' show ChatPreferencesPageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatPreferencesPageModel
    extends FlutterFlowModel<ChatPreferencesPageWidget> {
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
