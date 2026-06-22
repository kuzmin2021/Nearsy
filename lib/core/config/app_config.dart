import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class AppConfig {
  static String get supabaseUrl {
    const envUrl = String.fromEnvironment('SUPABASE_URL');

    if (envUrl.isNotEmpty) {
      return envUrl;
    }

    if (!kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android &&
        _isAndroidEmulator) {
      return 'http://10.0.2.2:54321';
    }

    return 'http://thecashcow.xyz:8000';
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

  static String get supabaseAnonKey {
    const envKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    return envKey.isNotEmpty
        ? envKey
        : 'sb_publishable_5EDmvk5KX_9MhjP6JrUmTc_R1jPVaq2';
  }

  static String get supabaseSecretKey {
    const envKey = String.fromEnvironment('SUPABASE_SECRET_KEY');
    return envKey.isNotEmpty
        ? envKey
        : 'YOUR_SUPABASE_SECRET_KEY';
  }

  AppConfig._();
}
