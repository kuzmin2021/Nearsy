import '/backend/supabase/supabase.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/floter/floter_widgets.dart';
import 'dart:ui';
import '/floter/custom_functions.dart' as functions;
import 'profile_languages_page_widget.dart' show ProfileLanguagesPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileLanguagesPageModel
    extends FloterModel<ProfileLanguagesPageWidget> {
  ///  Local state fields for this page.

  List<String> languages = [''];
  void addToLanguages(String item) => languages.add(item);
  void removeFromLanguages(String item) => languages.remove(item);
  void removeAtIndexFromLanguages(int index) => languages.removeAt(index);
  void insertAtIndexInLanguages(int index, String item) =>
      languages.insert(index, item);
  void updateLanguagesAtIndex(int index, Function(String) updateFn) =>
      languages[index] = updateFn(languages[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
