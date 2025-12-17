// lib/models/item.dart
class Item {
  final String id;
  final String title;
  final String description;
  final String location;
  final String finderId;
  final DateTime createdAt;
  final bool claimed;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.finderId,
    required this.createdAt,
    required this.claimed,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'].toString(),
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      finderId: json['finder_id'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      claimed: json['claimed'] as bool,
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'description': description,
      'location': location,
    };
  }
}
