import '/auth/supabase_auth/auth_util.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'reset_password_page_widget.dart' show ResetPasswordPageWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ResetPasswordPageModel extends FloterModel<ResetPasswordPageWidget> {
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
