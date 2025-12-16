import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/item.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_item_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/item_detail_screen.dart';
import 'screens/chat_screen.dart';
import 'utils/injector.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setup();
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
