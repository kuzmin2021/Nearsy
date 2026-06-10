class Conversation {
  Conversation({
    required this.id,
    required this.user1,
    required this.user2,
    this.matchCreatedAt,
    this.lastMessageAt,
    this.lastMessageBody,
    this.otherUserName,
    this.otherUserAvatar,
    this.otherUserAge,
    this.lastMessageSenderId,
    this.isUnread = false,
    this.lastMessagePhoto,
  });

  final int id;
  final String user1;
  final String user2;
  final DateTime? matchCreatedAt;
  final DateTime? lastMessageAt;
  final String? lastMessageBody;
  final String? lastMessagePhoto;
  final String? otherUserName;
  final String? otherUserAvatar;
  final int? otherUserAge;
  final String? lastMessageSenderId;
  final bool isUnread;

  String? otherUserId(String currentUserId) {
    if (user1 == currentUserId) return user2;
    if (user2 == currentUserId) return user1;
    return null;
  }
}

class Message {
  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.body,
    required this.createdAt,
    this.photoUrl,
    this.readAt,
    this.isOwn = false,
  });

  final int id;
  final int conversationId;
  final String senderId;
  final String body;
  final DateTime createdAt;
  final String? photoUrl;
  final DateTime? readAt;
  final bool isOwn;

  bool get isRead => readAt != null;

  Message copyWith({DateTime? readAt}) {
    return Message(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      body: body,
      createdAt: createdAt,
      photoUrl: photoUrl,
      readAt: readAt ?? this.readAt,
      isOwn: isOwn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'body': body,
      'created_at': createdAt.toUtc().toIso8601String(),
      'photo_url': photoUrl,
      'read_at': readAt?.toUtc().toIso8601String(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map, {String? currentUserId}) {
    return Message(
      id: map['id'] as int,
      conversationId: map['conversation_id'] as int,
      senderId: map['sender_id'] as String? ?? '',
      body: map['body'] as String? ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : DateTime.now(),
      photoUrl: map['photo_url'] as String?,
      readAt: map['read_at'] != null
          ? DateTime.tryParse(map['read_at'] as String)
          : null,
      isOwn: (map['sender_id'] as String?) == currentUserId,
    );
  }
}
