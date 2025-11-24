// lib/screens/add_item_screen.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/item_service.dart';
import '../models/item.dart';

class AddItemScreen extends StatelessWidget {
  final ItemService itemService = GetIt.I<ItemService>();

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Add Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newItem = Item(
                  title: titleController.text,
                  description: descriptionController.text,
                );
                bool success = await itemService.addItem(newItem);
                if (success) {
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Failed to add item')));
                }
              },
              child: Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}
