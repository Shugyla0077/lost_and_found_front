// lib/screens/add_item_screen.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../l10n/l10n.dart';
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
      appBar: AppBar(title: Text(context.l10n.addItem)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: context.l10n.title),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: context.l10n.description),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: context.l10n.location),
            ),
            SizedBox(height: 16),
            Text(
              context.l10n.contactPrivateAddItemHint,
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
                      .showSnackBar(SnackBar(content: Text(context.l10n.addItemFailed(e.toString()))));
                }
              },
              child: Text(context.l10n.addItem),
            ),
          ],
        ),
      ),
    );
  }
}
