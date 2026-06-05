import '/floter/floter_util.dart';
import 'profile_height_page_widget.dart' show ProfileHeightPageWidget;
import 'package:flutter/material.dart';

class ProfileHeightPageModel extends FloterModel<ProfileHeightPageWidget> {
  ///  Local state fields for this page.

  bool? isMetric = true;

  String? height = '';

  int? heightCm;

  ///  State fields for stateful widgets in this page.

  // State field(s) for ProfileHeightField widget.
  FocusNode? profileHeightFieldFocusNode;
  TextEditingController? profileHeightFieldTextController;
  String? Function(BuildContext, String?)?
      profileHeightFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    profileHeightFieldFocusNode?.dispose();
    profileHeightFieldTextController?.dispose();
  }
}
