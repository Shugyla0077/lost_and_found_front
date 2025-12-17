// home_screen.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/item.dart';
import '../services/item_service.dart';
import 'chat_screen.dart';
import 'my_items_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ItemService itemService = GetIt.I<ItemService>();
  int _currentIndex = 0;
  late Future<List<Item>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = itemService.fetchItems();
  }

  Future<void> _refreshItems() async {
    setState(() {
      _itemsFuture = itemService.fetchItems();
    });
    await _itemsFuture;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(
        itemsFuture: _itemsFuture,
        onRefresh: _refreshItems,
      ),
      ChatScreen(),
      MyItemsScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Lost & Found'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/addItem').then((_) => _refreshItems());
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFBDFF6C),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'My Items',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    required this.itemsFuture,
    required this.onRefresh,
  });

  final Future<List<Item>> itemsFuture;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: FutureBuilder<List<Item>>(
        future: itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Failed to load items: ${snapshot.error}'),
                ),
              ],
            );
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return ListView(
              children: const [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No items yet. Add the first one!'),
                ),
              ],
            );
          }
          return ListView.builder(
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
                            item.claimed ? 'Claimed' : 'Available',
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
                    Navigator.pushNamed(
                      context,
                      '/itemDetail',
                      arguments: item,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
