// chat_screen.dart
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String itemTitle;

  // Constructor accepting itemTitle as an argument
  ChatScreen({Key? key, required this.itemTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chats')),
      body: Center(child: Text('Chat about: $itemTitle')),
    );
  }
}
