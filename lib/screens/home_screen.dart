import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';  // Import cached image package
import 'add_item_screen.dart';  // Assuming this screen is where users can add items
import 'chat_screen.dart';  // Assuming this is your Chat screen
import 'my_items_screen.dart';  // Assuming this is your My Items screen
import 'profile_screen.dart';  // Assuming this is your Profile screen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // List of widgets for different screens (pages)
  final List<Widget> _pages = [
    HomePage(),  // Assuming this is the home page widget
    ChatScreen(),  // Your Chat screen
    MyItemsScreen(),  // Your My Items screen
    ProfileScreen(),  // Your Profile screen
  ];

  // Example items list for GridView
  final List<String> items = List.generate(20, (index) => 'Item $index');

  @override
  void dispose() {
    // Dispose any controllers or resources if needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lost & Found'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddItemScreen()),
              );
            },
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xFFBDFF6C),
      body: _pages[_currentIndex],  // Display current page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
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
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,  // Adjust for the number of columns
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 20,  // Adjust this based on the number of items you need
      itemBuilder: (context, index) {
        // Example: Loading images efficiently
        return CachedNetworkImage(
          imageUrl: 'https://example.com/image.jpg', // Replace with actual image URL
          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
