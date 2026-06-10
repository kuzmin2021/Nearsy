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
    this.isOwn = false,
  });

  final int id;
  final int conversationId;
  final String senderId;
  final String body;
  final DateTime createdAt;
  final String? photoUrl;
  final bool isOwn;
}
