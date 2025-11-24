// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_item_screen.dart';
import 'utils/injector.dart';

void main() {
  setup(); // Внедрение зависимостей
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
      },
    );
  }
}
