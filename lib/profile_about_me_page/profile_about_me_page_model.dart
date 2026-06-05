import '/floter/floter_util.dart';
import 'profile_about_me_page_widget.dart' show ProfileAboutMePageWidget;
import 'package:flutter/material.dart';

class ProfileAboutMePageModel
    extends FloterModel<ProfileAboutMePageWidget> {
  ///  Local state fields for this page.

  String? about = '';

  ///  State fields for stateful widgets in this page.

  // State field(s) for ProfileAboutMeField widget.
  FocusNode? profileAboutMeFieldFocusNode;
  TextEditingController? profileAboutMeFieldTextController;
  String? Function(BuildContext, String?)?
      profileAboutMeFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    profileAboutMeFieldFocusNode?.dispose();
    profileAboutMeFieldTextController?.dispose();
  }
}
