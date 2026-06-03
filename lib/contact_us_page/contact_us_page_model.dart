import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import 'dart:ui';
import 'contact_us_page_widget.dart' show ContactUsPageWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
