// lib/services/chat_service.dart
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat.dart';
import '../models/message.dart';

abstract class ChatService {
  Future<List<Chat>> fetchChats();
  Future<List<Message>> fetchMessages(String itemId);
  Future<Message> sendMessage(String itemId, String text);
}

class ChatServiceImpl implements ChatService {
  final Dio dio;

  ChatServiceImpl(this.dio);

  Future<String?> _getToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return await user.getIdToken();
  }

  @override
  Future<List<Chat>> fetchChats() async {
    final token = await _getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await dio.get(
      '/chats/',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    final List<dynamic> data = response.data;
    return data.map((json) => Chat.fromJson(json)).toList();
  }

  @override
  Future<List<Message>> fetchMessages(String itemId) async {
    final token = await _getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await dio.get(
      '/chats/$itemId/messages/',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    final List<dynamic> data = response.data;
    return data.map((json) => Message.fromJson(json)).toList();
  }

  @override
  Future<Message> sendMessage(String itemId, String text) async {
    final token = await _getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await dio.post(
      '/chats/$itemId/messages/send/',
      data: {'text': text},
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    return Message.fromJson(response.data);
  }
}
