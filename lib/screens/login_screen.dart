// lib/screens/login_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../l10n/l10n.dart';
import '../services/auth_service.dart';
import '../utils/locale_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = GetIt.I<AuthService>();
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  Map<String, Object?> _getNavArgs() {
    final raw = ModalRoute.of(context)?.settings.arguments;
    if (raw is Map) {
      final map = raw.cast<String, Object?>();
      return map;
    }
    return const {};
  }

  bool get _popOnSuccess {
    final args = _getNavArgs();
    final v = args['popOnSuccess'];
    return v == true;
  }

  Future<void> _resetPassword() async {
    final initialEmail = emailController.text.trim();
    var enteredEmail = initialEmail;

    final submittedEmail = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.l10n.resetPassword),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.resetPasswordHint,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: initialEmail,
                decoration: InputDecoration(labelText: context.l10n.email),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => enteredEmail = value.trim(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, enteredEmail),
              child: Text(context.l10n.sendResetLink),
            ),
          ],
        );
      },
    );

    if (!mounted || submittedEmail == null) return;
    if (submittedEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.emailRequired)),
      );
      return;
    }

    try {
      await authService.sendPasswordResetEmail(submittedEmail);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.passwordResetEmailSent)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.passwordResetFailed(e.toString()))),
      );
    }
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
        await authService.login(
          emailController.text.trim(),
          passwordController.text,
        );
        await FirebaseAuth.instance.currentUser!.getIdToken(true);
        await GetIt.I<LocaleController>().loadInitial();

        if (!mounted) return;
        final args = _getNavArgs();
        final next = args['next'];
        final nextArgs = args['nextArgs'];
        if (_popOnSuccess) {
          Navigator.pop(context, {'next': next, 'nextArgs': nextArgs});
          return;
        }
        if (next is String && next.isNotEmpty) {
          Navigator.pushReplacementNamed(context, next, arguments: nextArgs);
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.loginFailed(e.toString()))),
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
                                context.l10n.login,
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
                                  autofillHints: const [AutofillHints.password],
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
                                  child: Text(context.l10n.login),
                                ),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: _resetPassword,
                                  child: Text(context.l10n.forgotPassword),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/auth', arguments: _getNavArgs());
                          },
                          child: Text(context.l10n.noAccountRegister),
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
