import '../backend/supabase/supabase.dart';
import '../models/chat_models.dart';

class ChatService {
  static final ChatService _instance = ChatService._();
  factory ChatService() => _instance;
  ChatService._();

  SupabaseClient get _client => SupaFlow.client;

  Future<List<Conversation>> getConversations() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from('conversations')
        .select('id, user1, user2, match_created_at, last_message_at, last_message_id')
        .or('user1.eq.$userId,user2.eq.$userId')
        .order('last_message_at', ascending: false);

    final conversations = <Conversation>[];
    final otherUserIds = <String>[];

    for (final row in response) {
      final user1 = row['user1'] as String? ?? '';
      final user2 = row['user2'] as String? ?? '';
      final otherId = user1 == userId ? user2 : user1;
      otherUserIds.add(otherId);
    }

    final profiles = otherUserIds.isNotEmpty
        ? await _client
            .from('profiles')
            .select('user_id, display_name, avatar_url, birthday')
            .inFilter('user_id', otherUserIds)
        : <Map<String, dynamic>>[];

    final profileMap = <String, Map<String, dynamic>>{};
    for (final p in profiles) {
      profileMap[p['user_id'] as String] = p;
    }

    final lastMessages = <int, Map<String, dynamic>>{};
    final lastMessageIds = response
        .map((r) => r['last_message_id'] as int?)
        .whereType<int>()
        .toList();
    if (lastMessageIds.isNotEmpty) {
      final msgs = await _client
          .from('messages')
          .select('id, sender_id, body, photo_url')
          .inFilter('id', lastMessageIds);
      for (final m in msgs) {
        lastMessages[m['id'] as int] = m;
      }
    }

    for (final row in response) {
      final user1 = row['user1'] as String? ?? '';
      final user2 = row['user2'] as String? ?? '';
      final otherId = user1 == userId ? user2 : user1;
      final profile = profileMap[otherId];

      final lastMsgId = row['last_message_id'] as int?;
      final lastMsg = lastMsgId != null ? lastMessages[lastMsgId] : null;

      int? age;
      if (profile?['birthday'] is String) {
        final bday = DateTime.tryParse(profile!['birthday'] as String);
        if (bday != null) {
          age = DateTime.now().difference(bday).inDays ~/ 365;
        }
      }

      final hasPhoto = lastMsg?['photo_url'] is String && (lastMsg!['photo_url'] as String).isNotEmpty;
      final body = lastMsg?['body'] as String?;

      conversations.add(Conversation(
        id: row['id'] as int,
        user1: user1,
        user2: user2,
        matchCreatedAt: row['match_created_at'] != null
            ? DateTime.parse(row['match_created_at'] as String)
            : null,
        lastMessageAt: row['last_message_at'] != null
            ? DateTime.parse(row['last_message_at'] as String)
            : null,
        lastMessageBody: hasPhoto ? '[Photo]' : body,
        lastMessagePhoto: lastMsg?['photo_url'] as String?,
        lastMessageSenderId: lastMsg?['sender_id'] as String?,
        otherUserName: profile?['display_name'] as String?,
        otherUserAvatar: SupaFlow.safePhotoUrl(profile?['avatar_url'] as String?),
        otherUserAge: age,
      ));
    }

    return conversations;
  }

  Future<List<Message>> getMessages(int conversationId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _client
        .from('messages')
        .select('id, conversation_id, sender_id, body, created_at, photo_url, read_at')
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true);

    return response.map((row) {
      return Message(
        id: row['id'] as int,
        conversationId: row['conversation_id'] as int,
        senderId: row['sender_id'] as String? ?? '',
        body: row['body'] as String? ?? '',
        photoUrl: row['photo_url'] as String?,
        readAt: row['read_at'] != null
            ? DateTime.tryParse(row['read_at'] as String)
            : null,
        createdAt: row['created_at'] != null
            ? DateTime.parse(row['created_at'] as String)
            : DateTime.now(),
        isOwn: (row['sender_id'] as String?) == userId,
      );
    }).toList();
  }

  Future<Message?> sendMessage(int conversationId, String body) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null || body.trim().isEmpty) return null;

    final response = await _client.from('messages').insert({
      'conversation_id': conversationId,
      'sender_id': userId,
      'body': body.trim(),
    }).select('id, created_at').single();

    await _client.from('conversations').update({
      'last_message_at': DateTime.now().toUtc().toIso8601String(),
      'last_message_id': response['id'],
    }).eq('id', conversationId);

    return Message(
      id: response['id'] as int,
      conversationId: conversationId,
      senderId: userId,
      body: body.trim(),
      createdAt: response['created_at'] != null
          ? DateTime.parse(response['created_at'] as String)
          : DateTime.now(),
      isOwn: true,
    );
  }

  Future<Message?> sendPhoto(int conversationId, String photoPath) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final photoUrl = SupaFlow.chatPhotoUrl(photoPath);

    final response = await _client.from('messages').insert({
      'conversation_id': conversationId,
      'sender_id': userId,
      'body': '',
      'photo_url': photoUrl,
    }).select('id, created_at').single();

    await _client.from('conversations').update({
      'last_message_at': DateTime.now().toUtc().toIso8601String(),
      'last_message_id': response['id'],
    }).eq('id', conversationId);

    return Message(
      id: response['id'] as int,
      conversationId: conversationId,
      senderId: userId,
      body: '',
      photoUrl: photoUrl,
      createdAt: response['created_at'] != null
          ? DateTime.parse(response['created_at'] as String)
          : DateTime.now(),
      isOwn: true,
    );
  }

  Future<String?> uploadChatPhoto(String userId, dynamic fileBytes, String fileName) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final storagePath = '$userId/$timestamp-$fileName';

    final bucket = _client.storage.from('chat_photos');
    await bucket.uploadBinary(storagePath, fileBytes);

    return storagePath;
  }

  Future<Map<String, dynamic>?> getConversationDetails(int conversationId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _client
        .from('conversations')
        .select('id, user1, user2')
        .eq('id', conversationId)
        .maybeSingle();

    if (response == null) return null;

    final user1 = response['user1'] as String? ?? '';
    final user2 = response['user2'] as String? ?? '';
    final otherId = user1 == userId ? user2 : user1;

    final profileResp = await _client
        .from('profiles')
        .select('display_name, avatar_url, birthday')
        .eq('user_id', otherId)
        .maybeSingle();

    final profile = profileResp;
    int? age;
    if (profile?['birthday'] is String) {
      final bday = DateTime.tryParse(profile!['birthday'] as String);
      if (bday != null) {
        age = DateTime.now().difference(bday).inDays ~/ 365;
      }
    }

    return {
      'partnerName': profile?['display_name'] as String?,
      'partnerAvatar': SupaFlow.safePhotoUrl(profile?['avatar_url'] as String?),
      'partnerAge': age,
    };
  }

  Future<void> deleteConversation(int conversationId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    final resp = await _client
        .from('conversations')
        .select('deleted_for')
        .eq('id', conversationId)
        .single();

    final deletedFor = List<String>.from(resp['deleted_for'] ?? []);
    if (!deletedFor.contains(userId)) {
      deletedFor.add(userId);
      await _client.from('conversations').update({
        'deleted_for': deletedFor,
      }).eq('id', conversationId);
    }
  }

  RealtimeChannel? _conversationsChannel;

  void subscribeToConversations(void Function() onUpdate) {
    unsubscribe();
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    _conversationsChannel = _client
        .channel('public:conversations:${userId.hashCode}')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'conversations',
          callback: (_) => onUpdate(),
        )
        .subscribe();
  }

  void unsubscribe() {
    _conversationsChannel?.unsubscribe();
    _conversationsChannel = null;
  }

  RealtimeChannel? _messagesChannel;

  void subscribeToMessages(int conversationId, {
    required void Function(Message) onNewMessage,
    required void Function(Message) onReadReceipt,
  }) {
    unsubscribeFromMessages();
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    _messagesChannel = _client
        .channel('messages:$conversationId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) {
            final newRecord = payload.newRecord;
            final msgConvId = newRecord['conversation_id'] as int?;
            if (msgConvId == null) return;
            if (msgConvId != conversationId) return;
            final senderId = newRecord['sender_id'] as String? ?? '';
            if (senderId == userId) return;
            final msg = Message.fromMap(newRecord, currentUserId: userId);
            onNewMessage(msg);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'messages',
          callback: (payload) {
            final newRecord = payload.newRecord;
            final msgConvId = newRecord['conversation_id'] as int?;
            if (msgConvId == null) return;
            if (msgConvId != conversationId) return;
            if (newRecord['read_at'] == null) return;
            final senderId = newRecord['sender_id'] as String? ?? '';
            if (senderId != userId) return;
            final msg = Message.fromMap(newRecord, currentUserId: userId);
            onReadReceipt(msg);
          },
        )
        .subscribe();
  }

  Future<void> markMessagesAsRead(int conversationId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;
    try {
      await _client
          .from('messages')
          .update({'read_at': DateTime.now().toUtc().toIso8601String()})
          .eq('conversation_id', conversationId)
          .neq('sender_id', userId);
    } catch (_) {}
  }

  void unsubscribeFromMessages() {
    _messagesChannel?.unsubscribe();
    _messagesChannel = null;
  }

  Future<void> blockUser(String blockerId, String blockedId) async {
    try {
      await _client.from('blocks').insert({
        'blocker': blockerId,
        'blocked': blockedId,
      });
    } catch (_) {}
  }

  Future<void> deleteMatch(String user1, String user2) async {
    try {
      await _client
          .from('matches')
          .delete()
          .or('(user1.eq.$user1,user2.eq.$user2),(user1.eq.$user2,user2.eq.$user1)');
    } catch (_) {}
  }
}
