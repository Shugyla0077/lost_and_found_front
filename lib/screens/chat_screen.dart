// lib/screens/chat_screen.dart
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String itemTitle;

  ChatScreen({required this.itemTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat about "$itemTitle"')),
      body: Center(
        child: Text('Chat functionality will be added later'),
      ),
    );
  }
}
