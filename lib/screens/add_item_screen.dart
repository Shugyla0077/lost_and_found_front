// lib/screens/add_item_screen.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../l10n/l10n.dart';
import '../services/item_service.dart';
import '../models/item.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final ItemService itemService = GetIt.I<ItemService>();
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController locationController;

  String _selectedCategory = 'other';
  bool _isLoading = false;

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

  String _getLocale() {
    return Localizations.localeOf(context).languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final locale = _getLocale();

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.addItem)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: context.l10n.title,
                      prefixIcon: const Icon(Icons.title),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: context.l10n.description,
                      prefixIcon: const Icon(Icons.notes_outlined),
                    ),
                    maxLines: 3,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: context.l10n.location,
                      prefixIcon: const Icon(Icons.location_on_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: context.l10n.category,
                      prefixIcon: const Icon(Icons.category_outlined),
                    ),
                    items: itemCategories.map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat.id,
                        child: Text(cat.getName(locale)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.l10n.contactPrivateAddItemHint,
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _isLoading
                ? null
                : () async {
                    if (titleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.l10n.titleRequired)),
                      );
                      return;
                    }

                    setState(() => _isLoading = true);

                    try {
                      await itemService.addItem(
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim(),
                        location: locationController.text.trim(),
                        category: _selectedCategory,
                      );
                      if (!mounted) return;
                      Navigator.pop(context, true);
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.l10n.addItemFailed(e.toString()))),
                      );
                    } finally {
                      if (mounted) {
                        setState(() => _isLoading = false);
                      }
                    }
                  },
            icon: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add),
            label: Text(context.l10n.addItem),
          ),
        ],
      ),
    );
  }
}
