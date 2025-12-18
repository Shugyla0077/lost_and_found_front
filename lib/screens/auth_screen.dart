// lib/screens/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../l10n/l10n.dart';
import '../services/auth_service.dart';
import '../utils/locale_controller.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

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
    final scheme = Theme.of(context).colorScheme;

    Future<void> submit() async {
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
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.registrationFailed(e.toString()))),
        );
      }
    }

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Image.asset('assets/logo.png', width: 56, height: 56),
                              const SizedBox(height: 12),
                              Text(
                                context.l10n.appTitle,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                context.l10n.register,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  autofillHints: const [AutofillHints.email],
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelText: context.l10n.email,
                                    prefixIcon: const Icon(Icons.email_outlined),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  autofillHints: const [AutofillHints.newPassword],
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    labelText: context.l10n.password,
                                    prefixIcon: const Icon(Icons.lock_outline),
                                  ),
                                  onFieldSubmitted: (_) => submit(),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: submit,
                                  child: Text(context.l10n.register),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/login', arguments: _getNavArgs()),
                          child: Text(context.l10n.login),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
