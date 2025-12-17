import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../l10n/l10n.dart';
import '../models/item.dart';
import '../services/item_service.dart';
import 'item_detail_screen.dart';

class ClaimedItemsScreen extends StatefulWidget {
  const ClaimedItemsScreen({super.key});

  @override
  State<ClaimedItemsScreen> createState() => _ClaimedItemsScreenState();
}

class _ClaimedItemsScreenState extends State<ClaimedItemsScreen> {
  final ItemService itemService = GetIt.I<ItemService>();
  late Future<List<Item>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = itemService.fetchClaimedItems();
  }

  Future<void> _refresh() async {
    setState(() {
      _itemsFuture = itemService.fetchClaimedItems();
    });
    await _itemsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.claimedItems)),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Item>>(
          future: _itemsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(context.l10n.failedToLoadClaimedItems(snapshot.error.toString())),
                  ),
                ],
              );
            }

            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(context.l10n.noClaimedItemsYet),
                  ),
                ],
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(Icons.check, color: Colors.white),
                    ),
                    title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item.location),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ItemDetailScreen(item: item)),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

