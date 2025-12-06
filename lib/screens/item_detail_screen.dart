// lib/screens/item_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/item.dart';

class ItemDetailScreen extends StatelessWidget {
  final Item item;

  ItemDetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title, style: Theme.of(context).textTheme.displayLarge),
            SizedBox(height: 10),
            Text(item.description),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Chat functionality will be added later
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Chat functionality coming soon')));
              },
              child: Text('Chat with the user'),
            ),
          ],
        ),
      ),
    );
  }
}
