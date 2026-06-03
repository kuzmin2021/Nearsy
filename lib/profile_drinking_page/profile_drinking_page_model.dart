import '/backend/supabase/supabase.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import 'dart:ui';
import '/floter/custom_functions.dart' as functions;
import 'profile_drinking_page_widget.dart' show ProfileDrinkingPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileDrinkingPageModel
    extends FloterModel<ProfileDrinkingPageWidget> {
  ///  Local state fields for this page.

  String? drinking = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
