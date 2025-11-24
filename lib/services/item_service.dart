// lib/services/item_service.dart
import '../models/item.dart';

abstract class ItemService {
  Future<List<Item>> fetchItems();
  Future<bool> addItem(Item item);
}

class ItemServiceImpl implements ItemService {
  List<Item> _items = [];

  @override
  Future<List<Item>> fetchItems() async {
    // Логика для получения списка вещей
    await Future.delayed(Duration(seconds: 1)); // имитация задержки
    return _items;
  }

  @override
  Future<bool> addItem(Item item) async {
    // Логика для добавления новой вещи
    await Future.delayed(Duration(seconds: 1)); // имитация задержки
    _items.add(item);
    return true;
  }
}