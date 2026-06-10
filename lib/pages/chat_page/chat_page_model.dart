import '/floter/floter_util.dart';
import '/models/chat_models.dart';
import '/services/chat_service.dart';
import 'chat_page_widget.dart' show ChatPageWidget;
import 'package:flutter/material.dart';

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
    messageTextFieldTextController.dispose();
    messageTextFieldFocusNode.dispose();
    scrollController.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void setConversationId(int? id) {
    conversationId = id;
    if (id != null) {
      loadConversationDetails();
      loadMessages();
    }
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
    } catch (_) {}
    isLoading = false;
    onStateChanged?.call();
    _scrollToBottom();
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
}
