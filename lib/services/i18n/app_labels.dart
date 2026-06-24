import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__app_locale_key__';

class AppLabels {
  AppLabels(this.locale);

  final Locale locale;

  static final Map<String, Map<String, dynamic>> _cache = {};
  static String _currentLang = 'en';

  static late SharedPreferences _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> loadTranslations(String languageCode) async {
    _currentLang = languages().contains(languageCode)
        ? languageCode
        : languageCode.split('_').first;
    await _load(_currentLang);
    if (_currentLang != 'en') await _load('en');
  }

  static Future<void> _load(String lang) async {
    if (_cache.containsKey(lang)) return;
    try {
      final json = await rootBundle.loadString('assets/i18n/$lang.json');
      _cache[lang] = jsonDecode(json) as Map<String, dynamic>;
    } catch (_) {}
  }

  static Future<void> storeLocale(String language) =>
      _prefs.setString(_kLocaleStorageKey, language);

  static Locale? getStoredLocale() {
    try {
      final locale = _prefs.getString(_kLocaleStorageKey) ??
          _prefs.getString('__locale_key__');
      return locale != null && locale.isNotEmpty
          ? _resolveLocale(locale)
          : null;
    } catch (_) {
      return null;
    }
  }

  static Locale _resolveLocale(String language) => language.contains('_')
      ? _localeFromParts(language.split('_').first, language.split('_').last)
      : Locale(language);

  static Locale _localeFromParts(String languageCode, String localePart) {
    if (localePart.length == 4) {
      return Locale.fromSubtags(
        languageCode: languageCode,
        scriptCode: localePart,
      );
    }
    return Locale(languageCode, localePart);
  }

  static AppLabels of(BuildContext context) =>
      Localizations.of<AppLabels>(context, AppLabels)!;

  String get(String key) {
    final parts = key.split('.');
    dynamic node = _cache[_currentLang];
    for (final part in parts) {
      if (node is Map) {
        node = node[part];
      } else {
        node = null;
        break;
      }
    }
    if (node is String && node.isNotEmpty) return node;
    node = _cache['en'];
    for (final part in parts) {
      if (node is Map) {
        node = node[part];
      } else {
        node = null;
        break;
      }
    }
    return node is String ? node : key;
  }

  static String t(String key) {
    final parts = key.split('.');
    dynamic node = _cache[_currentLang];
    for (final part in parts) {
      if (node is Map) {
        node = node[part];
      } else {
        node = null;
        break;
      }
    }
    if (node is String && node.isNotEmpty) return node;
    node = _cache['en'];
    for (final part in parts) {
      if (node is Map) {
        node = node[part];
      } else {
        node = null;
        break;
      }
    }
    return node is String ? node : key;
  }

  String profileLabel(String attribute, String value) {
    for (final lang in [_currentLang, 'en']) {
      final localized = _cache[lang]?['profile_attributes']?[attribute]?[value];
      if (localized is String && localized.isNotEmpty) return localized;
    }
    return value;
  }

  static String staticProfileLabel(String attribute, String value) {
    for (final lang in [_currentLang, 'en']) {
      final localized = _cache[lang]?['profile_attributes']?[attribute]?[value];
      if (localized is String && localized.isNotEmpty) return localized;
    }
    return value;
  }

  static List<String> languages() => [
        'en',
        'zh_Hans',
        'hi',
        'es',
        'fr',
        'ar',
        'bn',
        'ru',
        'pt',
        'pt_BR',
        'it',
        'ur',
        'id',
        'de',
        'ja',
        'pcm',
        'ar_EG',
        'mr',
        'te',
        'tr',
        'ta',
        'yue',
      ];
}
