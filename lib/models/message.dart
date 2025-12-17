// lib/models/message.dart
class Message {
  final String id;
  final String itemId;
  final String senderId;
  final String text;
  final DateTime createdAt;
  final bool read;

  Message({
    required this.id,
    required this.itemId,
    required this.senderId,
    required this.text,
    required this.createdAt,
    required this.read,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      itemId: json['item_id'] as String,
      senderId: json['sender_id'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      read: json['read'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}
