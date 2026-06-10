import '/backend/supabase/supabase.dart';

class UserSettingsService {
  Future<String?> getChatMode(String userId) async {
    final resp = await SupaFlow.client
        .from('user_settings')
        .select('chat_mode')
        .eq('user_id', userId)
        .maybeSingle();
    return resp?['chat_mode'] as String?;
  }

  Future<void> setChatMode(String userId, String mode) async {
    await SupaFlow.client
        .from('user_settings')
        .update({'chat_mode': mode})
        .eq('user_id', userId);
  }
}
