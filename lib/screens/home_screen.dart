// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/item.dart';
import '../services/item_service.dart';
import 'add_item_screen.dart';

class HomeScreen extends StatelessWidget {
  final ItemService itemService = GetIt.I<ItemService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: FutureBuilder<List<Item>>(
        future: itemService.fetchItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching items'));
          } else {
            final items = snapshot.data ?? [];
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index].title),
                  subtitle: Text(items[index].description),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
