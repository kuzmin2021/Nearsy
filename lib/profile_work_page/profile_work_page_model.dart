import '/backend/supabase/supabase.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import 'dart:ui';
import 'profile_work_page_widget.dart' show ProfileWorkPageWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileWorkPageModel extends FloterModel<ProfileWorkPageWidget> {
  ///  Local state fields for this page.

  String? work = '';

  ///  State fields for stateful widgets in this page.

  // State field(s) for ProfileWorkField widget.
  FocusNode? profileWorkFieldFocusNode;
  TextEditingController? profileWorkFieldTextController;
  String? Function(BuildContext, String?)?
      profileWorkFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    profileWorkFieldFocusNode?.dispose();
    profileWorkFieldTextController?.dispose();
  }
}
