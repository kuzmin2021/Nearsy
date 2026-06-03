import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'auth_page_widget.dart' show AuthPageWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AuthPageModel extends FloterModel<AuthPageWidget> {
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
