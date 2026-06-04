class AppConfig {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'http://127.0.0.1:54321',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH',
  );

  static const String supabaseSecretKey = String.fromEnvironment(
    'SUPABASE_SECRET_KEY',
    defaultValue:
        'YOUR_SUPABASE_SECRET_KEY',
  );

  AppConfig._();
}
