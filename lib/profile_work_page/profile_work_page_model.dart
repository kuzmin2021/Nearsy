import '/floter/floter_util.dart';
import 'profile_work_page_widget.dart' show ProfileWorkPageWidget;
import 'package:flutter/material.dart';

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
