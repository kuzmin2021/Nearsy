import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import '/floter/floter_util.dart';

export 'database/database.dart';

String _kSupabaseUrl = 'https://mkmyybajywmljytduftp.supabase.co';
String _kSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1rbXl5YmFqeXdtbGp5dGR1ZnRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc5MDkxNDcsImV4cCI6MjA5MzQ4NTE0N30.DVlVT6CgXQ7G7HHCwjqAflj_8_PxHm6FLV15jLy5yt8';

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  final _supabase = Supabase.instance.client;
  static SupabaseClient get client => instance._supabase;

  static Future initialize() => Supabase.initialize(
        url: _kSupabaseUrl,
        headers: {
          'X-Client-Info': 'flutterflow',
        },
        anonKey: _kSupabaseAnonKey,
        debug: false,
        authOptions:
            FlutterAuthClientOptions(authFlowType: AuthFlowType.implicit),
      );
}
