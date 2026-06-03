import '/backend/supabase/supabase.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import 'dart:ui';
import 'profile_location_page_widget.dart' show ProfileLocationPageWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileLocationPageModel
    extends FloterModel<ProfileLocationPageWidget> {
  ///  Local state fields for this page.

  String? location = '';

  ///  State fields for stateful widgets in this page.

  // State field(s) for ProfileLocationField widget.
  FocusNode? profileLocationFieldFocusNode;
  TextEditingController? profileLocationFieldTextController;
  String? Function(BuildContext, String?)?
      profileLocationFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    profileLocationFieldFocusNode?.dispose();
    profileLocationFieldTextController?.dispose();
  }
}
