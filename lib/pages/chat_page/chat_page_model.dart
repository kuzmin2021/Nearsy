import '/floter/floter_util.dart';
import '/backend/supabase/supabase.dart';
import '/models/chat_models.dart';
import '/services/chat_service.dart';
import 'chat_page_widget.dart' show ChatPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:typed_data';

class ChatPageModel extends FloterModel<ChatPageWidget> {
  VoidCallback? onStateChanged;
  List<Message> messages = [];
  bool isLoading = true;
  int? conversationId;
  String? partnerName;
  String? partnerAvatar;
  int? partnerAge;
  final _chatService = ChatService();
  late TextEditingController messageTextFieldTextController;
  late FocusNode messageTextFieldFocusNode;
  late ScrollController scrollController;
  String? messageText = '';
  String? Function(BuildContext, String?)? messageTextFieldTextControllerValidator;

  @override
  void initState(BuildContext context) {
    messageTextFieldTextController = TextEditingController();
    messageTextFieldFocusNode = FocusNode();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    _chatService.unsubscribeFromMessages();
    messageTextFieldTextController.dispose();
    messageTextFieldFocusNode.dispose();
    scrollController.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _doScrollToBottom(3);
    });
  }

  void _doScrollToBottom(int attempts) {
    if (!scrollController.hasClients || attempts <= 0) return;
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _doScrollToBottom(attempts - 1);
    });
  }

  void setConversationId(int? id) {
    conversationId = id;
    if (id != null) {
      _subscribeToMessages();
      loadConversationDetails();
      loadMessages();
    }
  }

  void _subscribeToMessages() {
    if (conversationId == null) return;
    _chatService.subscribeToMessages(
      conversationId!,
      onNewMessage: (msg) {
        messages.add(msg);
        onStateChanged?.call();
        _scrollToBottom();
        _markMessagesAsRead();
      },
      onReadReceipt: (msg) {
        final idx = messages.indexWhere((m) => m.id == msg.id);
        if (idx != -1) {
          messages[idx] = messages[idx].copyWith(readAt: msg.readAt);
          onStateChanged?.call();
        }
      },
    );
  }

  Future<void> _markMessagesAsRead() async {
    if (conversationId == null) return;
    await _chatService.markMessagesAsRead(conversationId!);
  }

  Future<void> loadConversationDetails() async {
    if (conversationId == null) return;
    final details = await _chatService.getConversationDetails(conversationId!);
    if (details != null) {
      partnerName = details['partnerName'] as String?;
      partnerAvatar = details['partnerAvatar'] as String?;
      partnerAge = details['partnerAge'] as int?;
      onStateChanged?.call();
    }
  }

  Future<void> loadMessages() async {
    if (conversationId == null) return;
    isLoading = true;
    onStateChanged?.call();
    try {
      messages = await _chatService.getMessages(conversationId!);
    } catch (e) {
      debugPrint('ChatPageModel.loadMessages error: $e');
    }
    isLoading = false;
    onStateChanged?.call();
    _scrollToBottom();
    _markMessagesAsRead();
  }

  Future<void> sendMessage() async {
    final text = messageTextFieldTextController.text.trim();
    if (text.isEmpty || conversationId == null) return;
    messageTextFieldTextController.clear();
    final sent = await _chatService.sendMessage(conversationId!, text);
    if (sent != null) {
      messages.add(sent);
      onStateChanged?.call();
      _scrollToBottom();
    }
  }

  Future<void> sendPhoto(Uint8List bytes, String fileName) async {
    if (conversationId == null) return;
    final userId = SupaFlow.client.auth.currentUser?.id;
    if (userId == null) return;
    final storagePath = await _chatService.uploadChatPhoto(userId, bytes, fileName);
    if (storagePath == null) return;
    final message = await _chatService.sendPhoto(conversationId!, storagePath);
    if (message != null) {
      messages.add(message);
      onStateChanged?.call();
      _scrollToBottom();
    }
  }
}
