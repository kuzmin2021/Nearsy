import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'profile_about_me_page_widget.dart' show ProfileAboutMePageWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileAboutMePageModel
    extends FlutterFlowModel<ProfileAboutMePageWidget> {
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
