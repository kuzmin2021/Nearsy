import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;

import '/core/config/app_config.dart';

export 'database/database.dart';

class SupaFlowHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }

  @override
  HttpClientRequest handleOverrideRequest(
    HttpClient client,
    Uri url,
    String method,
    HttpClientRequest request,
  ) {
    if (url.host == Uri.parse(AppConfig.supabaseUrl).host &&
        url.path.contains('/storage/v1/')) {
      final token = SupaFlow.client.auth.currentSession?.accessToken;
      if (token != null) {
        request.headers.set('Authorization', 'Bearer $token');
      }
      request.headers.set('apikey', AppConfig.supabaseAnonKey);
    }
    return request;
  }
}

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  final _supabase = Supabase.instance.client;
  static SupabaseClient get client => instance._supabase;

  static String userPhotoUrl(String storagePath) {
    final encodedPath =
        storagePath.split('/').map(Uri.encodeComponent).join('/');
    return '${AppConfig.supabaseUrl}/storage/v1/object/authenticated/user_photos/$encodedPath';
  }

  static String chatPhotoUrl(String storagePath) {
    final encodedPath =
        storagePath.split('/').map(Uri.encodeComponent).join('/');
    return '${AppConfig.supabaseUrl}/storage/v1/object/authenticated/chat_photos/$encodedPath';
  }

  static Map<String, String> get authHeaders {
    final token = client.auth.currentSession?.accessToken;
    return {
      if (token != null) 'Authorization': 'Bearer $token',
      'apikey': AppConfig.supabaseAnonKey,
    };
  }

  static String? resolvePhotoUrl(dynamic raw) {
    final path = raw is String ? raw.trim() : '';
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return userPhotoUrl(path);
  }

  static bool isValidPhotoUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    if (url.contains('figma.com/api/mcp/asset')) return false;
    return true;
  }

  static String? safePhotoUrl(String? url) {
    return isValidPhotoUrl(url) ? url : null;
  }

  static String? storagePathFromPhotoUrl(String photoUrl) {
    final uri = Uri.tryParse(photoUrl.trim());
    if (uri == null) return null;
    const markerPublic = '/storage/v1/object/public/user_photos/';
    const markerAuth = '/storage/v1/object/authenticated/user_photos/';
    for (final marker in [markerAuth, markerPublic]) {
      final index = uri.path.indexOf(marker);
      if (index >= 0) {
        final encodedPath = uri.path.substring(index + marker.length);
        return Uri.decodeComponent(encodedPath);
      }
    }
    return null;
  }

  static Future initialize() {
    final url = AppConfig.supabaseUrl;
    debugPrint('Supabase URL: $url');

    return Supabase.initialize(
      url: url,
      headers: {
        'X-Client-Info': 'flutterflow',
      },
      anonKey: AppConfig.supabaseAnonKey,
      debug: false,
      authOptions:
          FlutterAuthClientOptions(authFlowType: AuthFlowType.implicit),
    );
  }
}
