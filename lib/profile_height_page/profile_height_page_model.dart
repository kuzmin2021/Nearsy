import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'profile_height_page_widget.dart' show ProfileHeightPageWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileHeightPageModel extends FlutterFlowModel<ProfileHeightPageWidget> {
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
