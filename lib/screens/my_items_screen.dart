// my_items_screen.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/item.dart';
import '../services/item_service.dart';
import '../l10n/l10n.dart';
import 'item_detail_screen.dart';

class MyItemsScreen extends StatefulWidget {
  @override
  State<MyItemsScreen> createState() => _MyItemsScreenState();
}

class _MyItemsScreenState extends State<MyItemsScreen> {
  final ItemService itemService = GetIt.I<ItemService>();
  List<Item> items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadMyItems();
  }

  Future<void> _loadMyItems() async {
    if (!mounted) return;
    setState(() => loading = true);
    try {
      final fetchedItems = await itemService.fetchMyItems();
      print('Fetched ${fetchedItems.length} items');
      if (!mounted) return;
      setState(() {
        items = fetchedItems;
        loading = false;
      });
    } catch (e) {
      print('Error loading my items: $e');
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToLoadItems(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        context.l10n.noMyItemsYetTitle,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        context.l10n.noMyItemsYetSubtitle,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadMyItems,
                  child: ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: item.claimed ? Colors.green : Colors.orange,
                            child: Icon(
                              item.claimed ? Icons.check : Icons.schedule,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            item.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                item.location,
                                style: TextStyle(fontSize: 13),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    item.claimed ? Icons.verified : Icons.pending,
                                    size: 14,
                                    color: item.claimed ? Colors.green : Colors.orange,
                                  ),
                                  SizedBox(width: 4),
                                    Text(
                                      item.claimed ? context.l10n.claimed : context.l10n.waitingForOwner,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: item.claimed ? Colors.green : Colors.orange,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemDetailScreen(item: item),
                              ),
                            ).then((_) => _loadMyItems()); // Refresh after returning
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
