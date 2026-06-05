import '/floter/floter_util.dart';
import 'profile_languages_page_widget.dart' show ProfileLanguagesPageWidget;
import 'package:flutter/material.dart';

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
