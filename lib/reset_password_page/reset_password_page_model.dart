import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'reset_password_page_widget.dart' show ResetPasswordPageWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ResetPasswordPageModel extends FlutterFlowModel<ResetPasswordPageWidget> {
  ///  Local state fields for this page.

  String? email = '';

  ///  State fields for stateful widgets in this page.

  // State field(s) for ResetEmailField widget.
  FocusNode? resetEmailFieldFocusNode;
  TextEditingController? resetEmailFieldTextController;
  String? Function(BuildContext, String?)?
      resetEmailFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    resetEmailFieldFocusNode?.dispose();
    resetEmailFieldTextController?.dispose();
  }
}
