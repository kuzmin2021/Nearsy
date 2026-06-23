class AppConfig {
  static String get supabaseUrl {
    const envUrl = String.fromEnvironment('SUPABASE_URL');

    if (envUrl.isNotEmpty) {
      return envUrl;
    }

    return 'https://nearsy.online';
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
