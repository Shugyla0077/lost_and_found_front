// lib/services/item_service.dart
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/item.dart';

abstract class ItemService {
  Future<List<Item>> fetchItems({
    String? category,
    DateTime? dateFrom,
    DateTime? dateTo,
  });
  Future<List<Item>> fetchMyItems();
  Future<List<Item>> fetchClaimedItems();
  Future<Item> fetchItem(String id);
  Future<Item> addItem({
    required String title,
    required String description,
    required String location,
    required String category,
  });
  Future<Map<String, dynamic>> claimItem({required String id});
  Future<String> createRewardPayment({required int amountCents});
}

class ItemServiceImpl implements ItemService {
  ItemServiceImpl(this._dio);

  final Dio _dio;

  Future<void> _attachToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Not authenticated. Please sign in.');
    }
    final token = await user.getIdToken(true);
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  Future<List<Item>> fetchItems({
    String? category,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    // Собираем query параметры
    final Map<String, dynamic> queryParams = {};

    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }
    if (dateFrom != null) {
      queryParams['date_from'] = dateFrom.toIso8601String().split('T')[0];
    }
    if (dateTo != null) {
      queryParams['date_to'] = dateTo.toIso8601String().split('T')[0];
    }

    final res = await _dio.get(
      '/items/',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    final data = res.data as List<dynamic>;
    return data.map((e) => Item.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Item>> fetchMyItems() async {
    await _attachToken();
    final res = await _dio.get('/items/my/');
    final data = res.data as List<dynamic>;
    return data.map((e) => Item.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Item>> fetchClaimedItems() async {
    await _attachToken();
    final res = await _dio.get('/items/claimed/');
    final data = res.data as List<dynamic>;
    return data.map((e) => Item.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<Item> fetchItem(String id) async {
    final res = await _dio.get('/items/$id/');
    return Item.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<Item> addItem({
    required String title,
    required String description,
    required String location,
    required String category,
  }) async {
    await _attachToken();
    final res = await _dio.post('/items/create/', data: {
      'title': title,
      'description': description,
      'location': location,
      'category': category,
    });
    return Item.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<Map<String, dynamic>> claimItem({required String id}) async {
    await _attachToken();
    debugPrint('CLAIM headers: ${_dio.options.headers}');
    try {
      final res = await _dio.post('/items/$id/claim/');
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      debugPrint('CLAIM error response: ${e.response?.data}');
      rethrow;
    }
  }

  @override
  Future<String> createRewardPayment({required int amountCents}) async {
    await _attachToken();
    final res = await _dio.post('/payments/reward/', data: {
      'amount_cents': amountCents,
    });
    final data = res.data as Map<String, dynamic>;
    return data['checkout_url'] as String;
  }
}
