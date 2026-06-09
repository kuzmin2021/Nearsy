import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class AppConfig {
  static String get supabaseUrl {
    const envUrl = String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: 'http://127.0.0.1:54321',
    );

    if (envUrl != 'http://127.0.0.1:54321') {
      return envUrl;
    }

    if (!kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android &&
        _isAndroidEmulator) {
      return 'http://10.0.2.2:54321';
    }

    return envUrl;
  }

  static bool get _isAndroidEmulator {
    if (!Platform.isAndroid) {
      return false;
    }

    final details = Platform.operatingSystemVersion.toLowerCase();
    return details.contains('sdk_gphone') ||
        details.contains('emulator') ||
        details.contains('android sdk built for x86') ||
        details.contains('generic');
  }

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH',
  );

  static const String supabaseSecretKey = String.fromEnvironment(
    'SUPABASE_SECRET_KEY',
    defaultValue: 'YOUR_SUPABASE_SECRET_KEY',
  );

  AppConfig._();
}
