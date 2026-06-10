import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;

import '/core/config/app_config.dart';

export 'database/database.dart';

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  final _supabase = Supabase.instance.client;
  static SupabaseClient get client => instance._supabase;

  static String publicPhotoUrl(String storagePath) {
    final encodedPath =
        storagePath.split('/').map(Uri.encodeComponent).join('/');
    return '${AppConfig.supabaseUrl}/storage/v1/object/public/user_photos/$encodedPath';
  }

  static String chatPhotoUrl(String storagePath) {
    final encodedPath =
        storagePath.split('/').map(Uri.encodeComponent).join('/');
    return '${AppConfig.supabaseUrl}/storage/v1/object/public/chat_photos/$encodedPath';
  }

  static String? resolvePhotoUrl(dynamic raw) {
    final path = raw is String ? raw.trim() : '';
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return publicPhotoUrl(path);
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
    const marker = '/storage/v1/object/public/user_photos/';
    final index = uri.path.indexOf(marker);
    if (index < 0) return null;
    final encodedPath = uri.path.substring(index + marker.length);
    return Uri.decodeComponent(encodedPath);
  }

  static Future initialize() => Supabase.initialize(
        url: AppConfig.supabaseUrl,
        headers: {
          'X-Client-Info': 'flutterflow',
        },
        anonKey: AppConfig.supabaseAnonKey,
        debug: false,
        authOptions:
            FlutterAuthClientOptions(authFlowType: AuthFlowType.implicit),
      );
}
