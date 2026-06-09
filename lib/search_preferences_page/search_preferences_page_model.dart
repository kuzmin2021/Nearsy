import '/floter/floter_util.dart';
import 'search_preferences_page_widget.dart' show SearchPreferencesPageWidget;
import 'package:flutter/material.dart';

class SearchPreferencesPageModel
    extends FloterModel<SearchPreferencesPageWidget> {
  ///  Local state fields for this page.

  int? minAge = 20;

  int? maxAge = 50;

  ///  State fields for stateful widgets in this page.

  // State field(s) for Checkbox widget.
  bool? checkboxValue1;
  // State field(s) for Checkbox widget.
  bool? checkboxValue2;
  // State field(s) for Checkbox widget.
  bool? checkboxValue3;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
