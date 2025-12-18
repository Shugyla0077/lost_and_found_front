// chat_screen.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/chat.dart';
import '../services/chat_service.dart';
import '../l10n/l10n.dart';
import 'chat_messages_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.embedded = false, this.active = true});

  final bool embedded;
  final bool active;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService chatService = GetIt.I<ChatService>();
  List<Chat> chats = [];
  bool loading = true;
  bool _hasLoadedOnce = false;

  @override
  void initState() {
    super.initState();
    if (widget.active) {
      _loadChats();
      _hasLoadedOnce = true;
    } else {
      loading = false;
    }
  }

  @override
  void didUpdateWidget(covariant ChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.active && widget.active && !_hasLoadedOnce) {
      setState(() => loading = true);
      _hasLoadedOnce = true;
      _loadChats();
    }
  }

  Future<void> _loadChats() async {
    try {
      final fetchedChats = await chatService.fetchChats();
      if (mounted) {
        setState(() {
          chats = fetchedChats;
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.failedToLoadChats(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = loading
          ? Center(child: CircularProgressIndicator())
          : chats.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      SizedBox(height: 16),
                      Text(
                        context.l10n.noChatsYet,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 8),
                      Text(
                        context.l10n.claimItemToStartChatting,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadChats,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                              child: const Icon(Icons.inventory_2),
                            ),
                            title: Text(
                              chat.itemTitle,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              chat.lastMessage ?? context.l10n.noMessagesYetShort,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: chat.lastMessageAt != null
                                ? Text(
                                    _formatTime(chat.lastMessageAt!),
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                  )
                                : null,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatMessagesScreen(
                                    itemId: chat.itemId,
                                    itemTitle: chat.itemTitle,
                                  ),
                                ),
                              ).then((_) => _loadChats()); // Refresh after returning
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );

    if (widget.embedded) return body;
    return Scaffold(appBar: AppBar(title: Text(context.l10n.chats)), body: body);
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inDays > 0) {
      return context.l10n.timeDaysAgo(diff.inDays);
    } else if (diff.inHours > 0) {
      return context.l10n.timeHoursAgo(diff.inHours);
    } else if (diff.inMinutes > 0) {
      return context.l10n.timeMinutesAgo(diff.inMinutes);
    } else {
      return context.l10n.timeJustNow;
    }
  }
}
