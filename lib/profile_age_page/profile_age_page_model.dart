import '/backend/supabase/supabase.dart';
import '/floter/floter_drop_down.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import '/floter/form_field_controller.dart';
import 'dart:ui';
import '/floter/custom_functions.dart' as functions;
import 'profile_age_page_widget.dart' show ProfileAgePageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileAgePageModel extends FloterModel<ProfileAgePageWidget> {
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
