// lib/models/item.dart

/// Категории вещей
class ItemCategory {
  final String id;
  final String nameEn;
  final String nameRu;
  final String nameKk;

  const ItemCategory({
    required this.id,
    required this.nameEn,
    required this.nameRu,
    required this.nameKk,
  });

  String getName(String locale) {
    switch (locale) {
      case 'ru':
        return nameRu;
      case 'kk':
        return nameKk;
      default:
        return nameEn;
    }
  }
}

/// Список доступных категорий
const List<ItemCategory> itemCategories = [
  ItemCategory(id: 'electronics', nameEn: 'Electronics', nameRu: 'Электроника', nameKk: 'Электроника'),
  ItemCategory(id: 'clothing', nameEn: 'Clothing', nameRu: 'Одежда', nameKk: 'Киім'),
  ItemCategory(id: 'accessories', nameEn: 'Accessories', nameRu: 'Аксессуары', nameKk: 'Аксессуарлар'),
  ItemCategory(id: 'documents', nameEn: 'Documents', nameRu: 'Документы', nameKk: 'Құжаттар'),
  ItemCategory(id: 'keys', nameEn: 'Keys', nameRu: 'Ключи', nameKk: 'Кілттер'),
  ItemCategory(id: 'bags', nameEn: 'Bags/Backpacks', nameRu: 'Сумки/Рюкзаки', nameKk: 'Сөмкелер'),
  ItemCategory(id: 'other', nameEn: 'Other', nameRu: 'Другое', nameKk: 'Басқа'),
];

/// Получить категорию по ID
ItemCategory? getCategoryById(String id) {
  try {
    return itemCategories.firstWhere((c) => c.id == id);
  } catch (e) {
    return null;
  }
}

class Item {
  final String id;
  final String title;
  final String description;
  final String location;
  final String finderId;
  final DateTime createdAt;
  final bool claimed;
  final String category;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.finderId,
    required this.createdAt,
    required this.claimed,
    this.category = 'other',
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
      category: json['category'] as String? ?? 'other',
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'category': category,
    };
  }

  /// Получить название категории на нужном языке
  String getCategoryName(String locale) {
    final cat = getCategoryById(category);
    return cat?.getName(locale) ?? category;
  }
}
