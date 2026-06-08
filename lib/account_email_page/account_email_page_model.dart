import 'package:flutter/material.dart';

import '/floter/floter_util.dart';
import 'account_email_page_widget.dart' show AccountEmailPageWidget;

class AccountEmailPageModel extends FloterModel<AccountEmailPageWidget> {
  String? email = '';
  String? code = '';

  FocusNode? emailFieldFocusNode;
  TextEditingController? emailFieldTextController;
  String? Function(BuildContext, String?)? emailFieldTextControllerValidator;
  final codeFieldFocusNodes = <FocusNode>[];
  final codeFieldTextControllers = <TextEditingController>[];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    emailFieldFocusNode?.dispose();
    emailFieldTextController?.dispose();
    for (final focusNode in codeFieldFocusNodes) {
      focusNode.dispose();
    }
    for (final textController in codeFieldTextControllers) {
      textController.dispose();
    }
  }
}
