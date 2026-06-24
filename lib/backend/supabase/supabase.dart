import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '/backend/supabase/offline_aware_http_client.dart';
import '/core/config/app_config.dart';
import '/floter/floter_theme.dart';
import '/services/connectivity_service.dart';

export 'database/database.dart';

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  final _supabase = Supabase.instance.client;
  static SupabaseClient get client => instance._supabase;

  static final Map<String, String> _signedUrlCache = {};

  static Future<String> signedPhotoUrl(
      String bucket, String storagePath) async {
    final cacheKey = '$bucket:$storagePath';
    if (_signedUrlCache.containsKey(cacheKey)) {
      return _signedUrlCache[cacheKey]!;
    }
    final encoded = storagePath.split('/').map(Uri.encodeComponent).join('/');
    final signed =
        await client.storage.from(bucket).createSignedUrl(encoded, 604800);
    _signedUrlCache[cacheKey] = signed;
    return signed;
  }

  static String userPhotoUrl(String storagePath) {
    final encodedPath =
        storagePath.split('/').map(Uri.encodeComponent).join('/');
    return '${AppConfig.supabaseUrl}/storage/v1/object/public/user_photos/$encodedPath';
  }

  static String chatPhotoUrl(String storagePath) {
    final encodedPath =
        storagePath.split('/').map(Uri.encodeComponent).join('/');
    return '${AppConfig.supabaseUrl}/storage/v1/object/public/chat_photos/$encodedPath';
  }

  static Future<String> resolveDisplayUrl(dynamic raw) async {
    final path = raw is String ? raw.trim() : '';
    if (path.isEmpty) return '';
    if (path.startsWith('http') && !path.contains('/storage/v1/')) {
      return path;
    }
    final storagePath = storagePathFromPhotoUrl(path) ?? path;
    if (path.contains('chat_photos') || storagePath.contains('chat_photos')) {
      return signedPhotoUrl('chat_photos', storagePath);
    }
    return signedPhotoUrl('user_photos', storagePath);
  }

  static String? resolvePhotoUrl(dynamic raw) {
    return raw is String ? raw.trim() : null;
  }

  static bool isValidPhotoUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    if (url.contains('figma.com/api/mcp/asset')) return false;
    return true;
  }

  static String get _persistSessionKey {
    final hostPrefix = Uri.parse(AppConfig.supabaseUrl).host.split('.').first;
    return 'sb-$hostPrefix-auth-token';
  }

  static Future<void> clearPersistedAuthSession() async {
    final localStorage = SharedPreferencesLocalStorage(
      persistSessionKey: _persistSessionKey,
    );
    await localStorage.initialize();
    await localStorage.removePersistedSession();
  }

  static String? safePhotoUrl(String? url) {
    return isValidPhotoUrl(url) ? url : null;
  }

  static String? storagePathFromPhotoUrl(String photoUrl) {
    final uri = Uri.tryParse(photoUrl.trim());
    if (uri == null) return null;
    const markers = [
      '/storage/v1/object/public/user_photos/',
      '/storage/v1/object/authenticated/user_photos/',
      '/storage/v1/object/sign/user_photos/',
      '/storage/v1/object/public/chat_photos/',
      '/storage/v1/object/authenticated/chat_photos/',
      '/storage/v1/object/sign/chat_photos/',
    ];
    for (final marker in markers) {
      final index = uri.path.indexOf(marker);
      if (index >= 0) {
        final encodedPath = uri.path.substring(index + marker.length);
        return Uri.decodeComponent(encodedPath);
      }
    }
    return null;
  }

  static Future initialize(ConnectivityService connectivityService) {
    final url = AppConfig.supabaseUrl;
    debugPrint('Supabase URL: $url');

    return Supabase.initialize(
      url: url,
      headers: {
        'X-Client-Info': 'flutterflow',
      },
      anonKey: AppConfig.supabaseAnonKey,
      debug: false,
      httpClient: OfflineAwareHttpClient(
        http.Client(),
        connectivityService,
      ),
      authOptions: FlutterAuthClientOptions(
        authFlowType: AuthFlowType.implicit,
        localStorage: SharedPreferencesLocalStorage(
          persistSessionKey: _persistSessionKey,
        ),
      ),
    );
  }
}

class SupaPhoto extends StatelessWidget {
  const SupaPhoto({
    super.key,
    required this.imageSource,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.fadeInDuration = Duration.zero,
    this.fadeOutDuration = Duration.zero,
  });

  final dynamic imageSource;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Duration fadeInDuration;
  final Duration fadeOutDuration;

  @override
  Widget build(BuildContext context) {
    final defaultPlaceholder = placeholder ??
        Container(color: FloterTheme.of(context).secondaryBackground);
    final defaultError = errorWidget ?? defaultPlaceholder;

    if (imageSource == null ||
        (imageSource is String && (imageSource as String).isEmpty)) {
      return defaultPlaceholder;
    }

    return FutureBuilder<String>(
      future: SupaFlow.resolveDisplayUrl(imageSource),
      builder: (_, snap) {
        if (!snap.hasData) return defaultPlaceholder;
        return CachedNetworkImage(
          imageUrl: snap.data!,
          width: width,
          height: height,
          fit: fit,
          fadeInDuration: fadeInDuration,
          fadeOutDuration: fadeOutDuration,
          placeholder: (_, __) => defaultPlaceholder,
          errorWidget: (_, __, ___) => defaultError,
        );
      },
    );
  }
}
