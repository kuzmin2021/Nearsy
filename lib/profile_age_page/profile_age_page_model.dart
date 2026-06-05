import '/floter/floter_util.dart';
import '/floter/form_field_controller.dart';
import 'profile_age_page_widget.dart' show ProfileAgePageWidget;
import 'package:flutter/material.dart';

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
