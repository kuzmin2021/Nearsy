import 'package:flutter/material.dart';

import '/backend/supabase/supabase.dart';
import '/floter/floter_util.dart';
import '/index.dart';
import 'email_auth_page_widget.dart' show EmailAuthPageWidget;

class EmailAuthPageModel extends FloterModel<EmailAuthPageWidget> {
  ///  Local state fields for this page.

  String? emailMode = 'signIn';

  String? email = '';

  String? password = '';

  String? confirmPassword = '';

  ///  State fields for stateful widgets in this page.

  // State field(s) for EmailField widget.
  FocusNode? emailFieldFocusNode;
  TextEditingController? emailFieldTextController;
  String? Function(BuildContext, String?)? emailFieldTextControllerValidator;
  // State field(s) for PasswordField widget.
  FocusNode? passwordFieldFocusNode;
  TextEditingController? passwordFieldTextController;
  late bool passwordFieldVisibility;
  String? Function(BuildContext, String?)? passwordFieldTextControllerValidator;
  // State field(s) for ConfirmPasswordField widget.
  FocusNode? confirmPasswordFieldFocusNode;
  TextEditingController? confirmPasswordFieldTextController;
  late bool confirmPasswordFieldVisibility;
  String? Function(BuildContext, String?)?
      confirmPasswordFieldTextControllerValidator;
  // Stores action output result for [Backend Call - Insert Row] action in EmailRegisterButton widget.
  ProfilesRow? createdSignupProfile;

  @override
  void initState(BuildContext context) {
    passwordFieldVisibility = false;
    confirmPasswordFieldVisibility = false;
  }

  @override
  void dispose() {
    emailFieldFocusNode?.dispose();
    emailFieldTextController?.dispose();

    passwordFieldFocusNode?.dispose();
    passwordFieldTextController?.dispose();

    confirmPasswordFieldFocusNode?.dispose();
    confirmPasswordFieldTextController?.dispose();
  }
}
