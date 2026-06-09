import '/floter/floter_util.dart';
import '/index.dart';
import 'update_password_page_widget.dart' show UpdatePasswordPageWidget;
import 'package:flutter/material.dart';

class UpdatePasswordPageModel extends FloterModel<UpdatePasswordPageWidget> {
  ///  Local state fields for this page.

  String? password = '';

  String? confirmPassword = '';

  ///  State fields for stateful widgets in this page.

  // State field(s) for UpdatePasswordField widget.
  FocusNode? updatePasswordFieldFocusNode;
  TextEditingController? updatePasswordFieldTextController;
  late bool updatePasswordFieldVisibility;
  String? Function(BuildContext, String?)?
      updatePasswordFieldTextControllerValidator;
  // State field(s) for ConfirmUpdatePasswordField widget.
  FocusNode? confirmUpdatePasswordFieldFocusNode;
  TextEditingController? confirmUpdatePasswordFieldTextController;
  late bool confirmUpdatePasswordFieldVisibility;
  String? Function(BuildContext, String?)?
      confirmUpdatePasswordFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {
    updatePasswordFieldVisibility = false;
    confirmUpdatePasswordFieldVisibility = false;
  }

  @override
  void dispose() {
    updatePasswordFieldFocusNode?.dispose();
    updatePasswordFieldTextController?.dispose();

    confirmUpdatePasswordFieldFocusNode?.dispose();
    confirmUpdatePasswordFieldTextController?.dispose();
  }
}
