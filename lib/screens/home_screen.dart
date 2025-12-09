// home_screen.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'screens/chat_screen.dart';  // Import ChatScreen only here

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(), // HomePage screen
    ChatScreen(itemTitle: 'Sample Chat'),  // ChatScreen widget with a sample item title
    MyItemsScreen(),  // My Items screen
    ProfileScreen(),  // Profile screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lost & Found'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigate to ChatScreen using named route
              Navigator.pushNamed(
                context,
                '/chat',
                arguments: 'Some Title',  // Pass any arguments here if necessary
              );
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFBDFF6C),
      body: _pages[_currentIndex],  // Display the page based on _currentIndex
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;  // Change the selected tab index
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
    return Center(
      child: Text(
        'Welcome to Lost & Found',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class MyItemsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Items')),
      body: Center(child: Text('This is the My Items page')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('This is the Profile page')),
    );
  }
}
