import '/components/lookaround_bottom_nav_widget.dart';
import '/floter/floter_util.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/models/chat_models.dart';
import '/services/chat_service.dart';
import 'matches_page_widget.dart' show MatchesPageWidget;
import 'dart:async';
import 'package:flutter/material.dart';

class MatchesPageModel extends FloterModel<MatchesPageWidget> {
  VoidCallback? onStateChanged;

  List<Conversation> conversations = [];
  bool isLoading = true;
  String loadError = '';

  late LookaroundBottomNavModel lookaroundBottomNavModel;

  final _chatService = ChatService();

  @override
  void initState(BuildContext context) {
    lookaroundBottomNavModel =
        createModel(context, () => LookaroundBottomNavModel());
    loadConversations();
  }

  @override
  void dispose() {
    _chatService.unsubscribe();
    lookaroundBottomNavModel.dispose();
  }

  Future<void> loadConversations() async {
    isLoading = true;
    loadError = '';
    onStateChanged?.call();

    try {
      conversations = await _chatService.getConversations();
      isLoading = false;
    } catch (e) {
      loadError = e.toString();
      isLoading = false;
    }
    onStateChanged?.call();
  }

  Future<void> deleteConversation(Conversation c) async {
    final userId = currentUserUid;
    try {
      await _chatService.deleteConversation(c.id);
      final otherId = c.otherUserId(userId);
      if (otherId != null) {
        await _chatService.deleteMatch(userId, otherId);
      }
      conversations.remove(c);
      onStateChanged?.call();
    } catch (_) {}
  }

  void blockUser(Conversation c) {
    final userId = currentUserUid;
    final otherId = c.otherUserId(userId);
    if (otherId != null) {
      _chatService.blockUser(userId, otherId);
      _chatService.deleteMatch(userId, otherId);
    }
    conversations.remove(c);
    onStateChanged?.call();
  }
}
