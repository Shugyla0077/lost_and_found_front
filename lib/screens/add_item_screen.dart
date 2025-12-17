// lib/screens/add_item_screen.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/item_service.dart';

class AddItemScreen extends StatefulWidget {
  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final ItemService itemService = GetIt.I<ItemService>();
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController locationController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    locationController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            SizedBox(height: 16),
            Text(
              'Your contact will remain private. Owners can contact you through chat after claiming.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  await itemService.addItem(
                    title: titleController.text,
                    description: descriptionController.text,
                    location: locationController.text,
                  );
                  if (!mounted) return;
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Failed to add item: $e')));
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
