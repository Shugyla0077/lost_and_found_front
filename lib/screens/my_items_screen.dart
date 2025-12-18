// my_items_screen.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/item.dart';
import '../services/item_service.dart';
import '../l10n/l10n.dart';
import 'item_detail_screen.dart';

class MyItemsScreen extends StatefulWidget {
  const MyItemsScreen({super.key, this.embedded = false, this.active = true});

  final bool embedded;
  final bool active;

  @override
  State<MyItemsScreen> createState() => _MyItemsScreenState();
}

class _MyItemsScreenState extends State<MyItemsScreen> {
  final ItemService itemService = GetIt.I<ItemService>();
  List<Item> items = [];
  bool loading = true;
  bool _hasLoadedOnce = false;

  @override
  void initState() {
    super.initState();
    if (widget.active) {
      _loadMyItems();
      _hasLoadedOnce = true;
    } else {
      loading = false;
    }
  }

  @override
  void didUpdateWidget(covariant MyItemsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.active && widget.active && !_hasLoadedOnce) {
      setState(() => loading = true);
      _hasLoadedOnce = true;
      _loadMyItems();
    }
  }

  Future<void> _loadMyItems() async {
    if (!mounted) return;
    setState(() => loading = true);
    try {
      final fetchedItems = await itemService.fetchMyItems();
      if (!mounted) return;
      setState(() {
        items = fetchedItems;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToLoadItems(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final body = loading
          ? Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 64, color: scheme.onSurfaceVariant),
                      SizedBox(height: 16),
                      Text(
                        context.l10n.noMyItemsYetTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 8),
                      Text(
                        context.l10n.noMyItemsYetSubtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadMyItems,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final statusBg = item.claimed ? scheme.tertiaryContainer : scheme.primaryContainer;
                      final statusFg = item.claimed ? scheme.onTertiaryContainer : scheme.onPrimaryContainer;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: statusBg,
                            foregroundColor: statusFg,
                            child: Icon(
                              item.claimed ? Icons.check : Icons.schedule,
                            ),
                          ),
                          title: Text(
                            item.title,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 6),
                              Text(
                                item.location,
                                style: TextStyle(fontSize: 13),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    item.claimed ? Icons.verified : Icons.pending,
                                    size: 14,
                                    color: item.claimed ? scheme.tertiary : scheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.claimed ? context.l10n.claimed : context.l10n.waitingForOwner,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
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
                );

    if (widget.embedded) return body;
    return Scaffold(appBar: AppBar(title: Text(context.l10n.myItems)), body: body);
  }
}
