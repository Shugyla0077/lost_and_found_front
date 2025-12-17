// chat_screen.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/chat.dart';
import '../services/chat_service.dart';
import '../l10n/l10n.dart';
import 'chat_messages_screen.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService chatService = GetIt.I<ChatService>();
  List<Chat> chats = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadChats();
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
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.chats)),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : chats.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        context.l10n.noChatsYet,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        context.l10n.claimItemToStartChatting,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadChats,
                  child: ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.inventory_2),
                        ),
                        title: Text(
                          chat.itemTitle,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          chat.lastMessage ?? context.l10n.noMessagesYetShort,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        trailing: chat.lastMessageAt != null
                            ? Text(
                                _formatTime(chat.lastMessageAt!),
                                style: TextStyle(fontSize: 12, color: Colors.grey),
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
                      );
                    },
                  ),
                ),
    );
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
