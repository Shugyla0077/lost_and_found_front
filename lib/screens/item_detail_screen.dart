// lib/screens/item_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/item.dart';
import '../services/item_service.dart';
import 'chat_messages_screen.dart';

class ItemDetailScreen extends StatefulWidget {
  final Item item;

  ItemDetailScreen({required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final ItemService itemService = GetIt.I<ItemService>();
  late Item _item;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      final detailed = await itemService.fetchItem(_item.id);
      setState(() {
        _item = detailed;
      });
    } catch (_) {
      // keep minimal info on failure
    }
  }

  Future<void> _claimItem() async {
    setState(() => _loading = true);
    try {
      await itemService.claimItem(id: _item.id);
      await _loadDetails();
      if (!mounted) return;

      // Navigate to chat after claiming
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatMessagesScreen(itemId: _item.id, itemTitle: _item.title),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item claimed! You can now chat with the finder.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to claim: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_item.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_item.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            Text(_item.description),
            const SizedBox(height: 8),
            Text('Location: ${_item.location}'),
            const SizedBox(height: 12),
            Text(
              'Contacts are kept private. Use chat to communicate.',
              style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            if (!_item.claimed) ...[
              Text(
                'Is this your item? Claim it to start chatting with the finder.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loading ? null : _claimItem,
                child: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Claim this item'),
              ),
            ] else ...[
              const Text(
                'Already claimed',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatMessagesScreen(itemId: _item.id, itemTitle: _item.title),
                    ),
                  );
                },
                icon: Icon(Icons.chat),
                label: Text('Open Chat'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
