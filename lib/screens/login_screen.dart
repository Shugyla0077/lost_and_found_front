// lib/screens/login_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../l10n/l10n.dart';
import '../services/auth_service.dart';
import '../utils/locale_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = GetIt.I<AuthService>();
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.login)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: context.l10n.email),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: context.l10n.password),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await authService.login(
                    emailController.text.trim(),
                    passwordController.text,
                  );
                  await FirebaseAuth.instance.currentUser!.getIdToken(true);
                  await GetIt.I<LocaleController>().loadInitial();

                  if (!mounted) return;
                  Navigator.pushReplacementNamed(context, '/home');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.loginFailed(e.toString()))),
                  );
                }
              },
              child: Text(context.l10n.login),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/auth');
              },
              child: Text(context.l10n.noAccountRegister),
            ),
          ],
        ),
      ),
    );
  }
}
