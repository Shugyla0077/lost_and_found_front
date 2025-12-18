// lib/screens/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../l10n/l10n.dart';
import '../services/auth_service.dart';
import '../utils/locale_controller.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService authService = GetIt.I<AuthService>();
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  Map<String, Object?> _getNavArgs() {
    final raw = ModalRoute.of(context)?.settings.arguments;
    if (raw is Map) return raw.cast<String, Object?>();
    return const {};
  }

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
      appBar: AppBar(title: Text(context.l10n.register)),
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
                  await authService.register(
                    emailController.text.trim(),
                    passwordController.text,
                  );
                  if (!mounted) return;
                  await FirebaseAuth.instance.currentUser?.getIdToken(true);
                  await GetIt.I<LocaleController>().loadInitial();

                  if (!mounted) return;
                  final args = _getNavArgs();
                  final next = args['next'];
                  final nextArgs = args['nextArgs'];
                  if (next is String && next.isNotEmpty) {
                    Navigator.pushNamedAndRemoveUntil(context, next, (r) => false, arguments: nextArgs);
                  } else {
                    Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.registrationFailed(e.toString()))),
                  );
                }
              },
              child: Text(context.l10n.register),
            ),
          ],
        ),
      ),
    );
  }
}
