import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app_labels.dart';

class AppLabelsDelegate extends LocalizationsDelegate<AppLabels> {
  const AppLabelsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLabels.languages().contains(locale.toString());

  @override
  Future<AppLabels> load(Locale locale) =>
      SynchronousFuture<AppLabels>(AppLabels(locale));

  @override
  bool shouldReload(AppLabelsDelegate old) => false;
}
