import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'update_password_page_widget.dart' show UpdatePasswordPageWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UpdatePasswordPageModel
    extends FlutterFlowModel<UpdatePasswordPageWidget> {
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
