import 'package:flutter/material.dart';

import '/floter/floter_util.dart';
import 'account_phone_page_widget.dart' show AccountPhonePageWidget;

class AccountPhonePageModel extends FloterModel<AccountPhonePageWidget> {
  String? phone = '';
  String? code = '';

  FocusNode? phoneFieldFocusNode;
  TextEditingController? phoneFieldTextController;
  String? Function(BuildContext, String?)? phoneFieldTextControllerValidator;
  final codeFieldFocusNodes = <FocusNode>[];
  final codeFieldTextControllers = <TextEditingController>[];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    phoneFieldFocusNode?.dispose();
    phoneFieldTextController?.dispose();
    for (final focusNode in codeFieldFocusNodes) {
      focusNode.dispose();
    }
    for (final textController in codeFieldTextControllers) {
      textController.dispose();
    }
  }
}
