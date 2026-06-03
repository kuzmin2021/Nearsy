import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'auth_page_widget.dart' show AuthPageWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AuthPageModel extends FlutterFlowModel<AuthPageWidget> {
  ///  Local state fields for this page.

  String? email = '';

  String? password = '';

  String? authMethod = 'phone';

  String? emailMode = 'signIn';

  String? phone = '';

  String? confirmPassword = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
