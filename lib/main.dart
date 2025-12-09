import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'models/item.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';  // Import HomeScreen here
import 'screens/add_item_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/item_detail_screen.dart';
import 'screens/chat_screen.dart';  // Import ChatScreen only here
import 'utils/injector.dart';

void main() {
  setup(); // Dependency Injection setup
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/addItem': (context) => AddItemScreen(),
        '/auth': (context) => AuthScreen(),
        '/itemDetail': (context) => ItemDetailScreen(item: ModalRoute.of(context)!.settings.arguments as Item),
        '/chat': (context) => ChatScreen(itemTitle: ModalRoute.of(context)!.settings.arguments as String), // ChatScreen route
      },
    );
  }
}
