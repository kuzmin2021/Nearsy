import 'package:flutter/material.dart';

import '/floter/floter_util.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/services/user_settings_service.dart';
import 'chat_preferences_page_widget.dart' show ChatPreferencesPageWidget;

class ChatPreferencesPageModel extends FloterModel<ChatPreferencesPageWidget> {
  String? selectedMode;
  bool isLoading = true;
  VoidCallback? onStateChanged;

  final _settingsService = UserSettingsService();

  @override
  void initState(BuildContext context) {
    _loadChatMode();
  }

  @override
  void dispose() {}

  Future<void> _loadChatMode() async {
    final userId = currentUserUid;
    if (userId.isEmpty) {
      selectedMode = 'unavailable';
      isLoading = false;
      onStateChanged?.call();
      return;
    }
    final mode = await _settingsService.getChatMode(userId);
    selectedMode = mode ?? 'unavailable';
    isLoading = false;
    onStateChanged?.call();
  }

  Future<void> saveChatMode(String mode) async {
    final userId = currentUserUid;
    if (userId.isEmpty) return;
    await _settingsService.setChatMode(userId, mode);
    selectedMode = mode;
    onStateChanged?.call();
  }
}
