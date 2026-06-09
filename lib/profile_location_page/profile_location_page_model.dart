import '/floter/floter_util.dart';
import 'profile_location_page_widget.dart' show ProfileLocationPageWidget;
import 'package:flutter/material.dart';

class ProfileLocationPageModel extends FloterModel<ProfileLocationPageWidget> {
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
