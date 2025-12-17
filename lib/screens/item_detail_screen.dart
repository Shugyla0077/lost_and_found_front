// lib/screens/item_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../models/item.dart';
import '../services/item_service.dart';
import '../l10n/l10n.dart';
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

  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  bool get _isOwner => _currentUserId != null && _item.finderId == _currentUserId;

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
    if (_isOwner) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.cannotClaimOwnItem)),
      );
      return;
    }

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
        SnackBar(content: Text(context.l10n.itemClaimed)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToClaim(e.toString()))),
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
            if (_isOwner) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.25)),
                ),
                child: Text(
                  context.l10n.ownItemBanner,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Text(_item.description),
            const SizedBox(height: 8),
            Text('${context.l10n.location}: ${_item.location}'),
            const SizedBox(height: 12),
            Text(
              context.l10n.contactsPrivate,
              style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            if (!_item.claimed && !_isOwner) ...[
              Text(context.l10n.claimYourItemHint, style: TextStyle(fontSize: 14)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loading ? null : _claimItem,
                child: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(context.l10n.claimThisItem),
              ),
            ] else if (!_item.claimed && _isOwner) ...[
              Text(context.l10n.cannotClaimOwnItem, style: TextStyle(color: Colors.grey)),
            ] else ...[
              Text(context.l10n.alreadyClaimed, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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
                label: Text(context.l10n.openChat),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
