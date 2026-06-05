import 'package:flutter/material.dart';

import '/floter/floter_util.dart';
import 'contact_us_page_widget.dart' show ContactUsPageWidget;

class ContactUsPageModel extends FloterModel<ContactUsPageWidget> {
  ///  Local state fields for this page.

  String? message = '';

  ///  State fields for stateful widgets in this page.

  // State field(s) for ContactMessageField widget.
  FocusNode? contactMessageFieldFocusNode;
  TextEditingController? contactMessageFieldTextController;
  String? Function(BuildContext, String?)?
      contactMessageFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    contactMessageFieldFocusNode?.dispose();
    contactMessageFieldTextController?.dispose();
  }
}
