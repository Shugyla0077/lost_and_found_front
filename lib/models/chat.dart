// lib/models/chat.dart
class Chat {
  final String chatId;
  final String itemId;
  final String itemTitle;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final DateTime createdAt;

  Chat({
    required this.chatId,
    required this.itemId,
    required this.itemTitle,
    this.lastMessage,
    this.lastMessageAt,
    required this.createdAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatId: json['chat_id'] as String,
      itemId: json['item_id'] as String,
      itemTitle: json['item_title'] as String,
      lastMessage: json['last_message'] as String?,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
