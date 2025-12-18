// lib/screens/item_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../models/item.dart';
import '../models/chat.dart';
import '../services/chat_service.dart';
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
  final ChatService chatService = GetIt.I<ChatService>();
  late Item _item;
  bool _loading = false;
  bool? _canOpenChat; // null = checking

  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;
  bool get _isAuthenticated => _currentUserId != null;

  bool get _isOwner => _currentUserId != null && _item.finderId == _currentUserId;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _loadDetails();
    _checkChatAccess();
  }

  Future<void> _loadDetails() async {
    try {
      final detailed = await itemService.fetchItem(_item.id);
      setState(() {
        _item = detailed;
      });
      await _checkChatAccess();
    } catch (_) {
      // keep minimal info on failure
    }
  }

  Future<void> _checkChatAccess() async {
    if (!_isAuthenticated || !_item.claimed) {
      if (mounted) setState(() => _canOpenChat = false);
      return;
    }

    if (mounted) setState(() => _canOpenChat = null);

    try {
      final List<Chat> chats = await chatService.fetchChats();
      final can = chats.any((c) => c.itemId == _item.id);
      if (mounted) setState(() => _canOpenChat = can);
    } catch (_) {
      if (mounted) setState(() => _canOpenChat = false);
    }
  }

  Future<void> _claimItem() async {
    if (!_isAuthenticated) {
      await Navigator.pushNamed(
        context,
        '/login',
        arguments: {'popOnSuccess': true},
      );
      if (!mounted) return;
      setState(() {});
      return;
    }
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
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(_item.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_item.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            if (_isOwner) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Text(
                  context.l10n.ownItemBanner,
                  style: TextStyle(fontWeight: FontWeight.w600, color: scheme.onPrimaryContainer),
                ),
              ),
              const SizedBox(height: 12),
            ],
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_item.description),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 18, color: scheme.onSurfaceVariant),
                        const SizedBox(width: 6),
                        Expanded(child: Text(_item.location)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.contactsPrivate,
                      style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 12),
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
              Text(context.l10n.cannotClaimOwnItem, style: TextStyle(color: scheme.onSurfaceVariant)),
            ] else ...[
              Text(context.l10n.alreadyClaimed, style: TextStyle(color: scheme.tertiary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              if (!_isAuthenticated) ...[
                ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.pushNamed(
                      context,
                      '/login',
                      arguments: {'popOnSuccess': true},
                    );
                    if (!mounted) return;
                    setState(() {});
                    await _checkChatAccess();
                  },
                  icon: const Icon(Icons.login),
                  label: Text(context.l10n.login),
                ),
              ] else if (_canOpenChat == null) ...[
                const Center(child: CircularProgressIndicator()),
              ] else if (_canOpenChat == true) ...[
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatMessagesScreen(itemId: _item.id, itemTitle: _item.title),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat),
                  label: Text(context.l10n.openChat),
                ),
              ] else ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lock_outline, color: scheme.onSurfaceVariant),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.chatAccessDenied,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                context.l10n.chatAccessDeniedHint,
                                style: TextStyle(color: scheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
