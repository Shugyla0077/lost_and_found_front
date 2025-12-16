// lib/models/item.dart
class Item {
  final String id;
  final String title;
  final String description;
  final String location;
  final String finderContact;
  final DateTime createdAt;
  final bool claimed;
  final String? ownerContact;
  final String? ownerMessage;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.finderContact,
    required this.createdAt,
    required this.claimed,
    this.ownerContact,
    this.ownerMessage,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'].toString(),
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      finderContact: json['finder_contact'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      claimed: json['claimed'] as bool,
      ownerContact: json['owner_contact'] as String?,
      ownerMessage: json['owner_message'] as String?,
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'finder_contact': finderContact,
    };
  }
}
