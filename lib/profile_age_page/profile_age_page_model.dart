import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'profile_age_page_widget.dart' show ProfileAgePageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileAgePageModel extends FlutterFlowModel<ProfileAgePageWidget> {
  ///  Local state fields for this page.

  String? birthday = '';

  String? birthdayDay = '--';

  String? birthdayMonth = '--';

  String? birthdayYear = '--';

  ///  State fields for stateful widgets in this page.

  // State field(s) for ProfileBirthdayDayDropdown widget.
  String? profileBirthdayDayDropdownValue;
  FormFieldController<String>? profileBirthdayDayDropdownValueController;
  // State field(s) for ProfileBirthdayMonthDropdown widget.
  String? profileBirthdayMonthDropdownValue;
  FormFieldController<String>? profileBirthdayMonthDropdownValueController;
  // State field(s) for ProfileBirthdayYearDropdown widget.
  String? profileBirthdayYearDropdownValue;
  FormFieldController<String>? profileBirthdayYearDropdownValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
