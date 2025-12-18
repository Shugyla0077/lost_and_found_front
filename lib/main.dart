import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'models/item.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_item_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/item_detail_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/claimed_items_screen.dart';
import 'screens/reward_payment_screen.dart';
import 'utils/injector.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'utils/locale_controller.dart';
import 'l10n/l10n.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setup();
  final localeController = getIt<LocaleController>();
  await localeController.loadInitial();
  runApp(MyApp(localeController: localeController));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.localeController});

  final LocaleController localeController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldMessengerState> _messengerKey = GlobalKey<ScaffoldMessengerState>();
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSub;
  Uri? _pendingDeepLink;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    final initial = await _appLinks.getInitialLink();
    _handleDeepLink(initial);
    _linkSub = _appLinks.uriLinkStream.listen(_handleDeepLink, onError: (_) {});
  }

  void _handleDeepLink(Uri? uri) {
    if (uri == null) return;
    if (uri.scheme != 'lostandfound') return;
    if (uri.host != 'payment') return;

    final ctx = _messengerKey.currentContext;
    if (ctx == null) {
      _pendingDeepLink = uri;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final pending = _pendingDeepLink;
        _pendingDeepLink = null;
        _handleDeepLink(pending);
      });
      return;
    }
    final l10n = AppLocalizations.of(ctx);
    if (l10n == null) return;

    if (uri.path == '/success') {
      closeInAppWebView();
      _messengerKey.currentState?.showSnackBar(
        SnackBar(content: Text(l10n.paymentThanks)),
      );
    } else if (uri.path == '/cancel') {
      closeInAppWebView();
      _messengerKey.currentState?.showSnackBar(
        SnackBar(content: Text(l10n.paymentCanceled)),
      );
    }
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.localeController,
      builder: (context, _) => MaterialApp(
        scaffoldMessengerKey: _messengerKey,
        onGenerateTitle: (context) => context.l10n.appTitle,
        theme: AppTheme.light(),
        locale: widget.localeController.locale,
        supportedLocales: const [
          Locale('en'),
          Locale('ru'),
          Locale('kk'),
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          // Default language is English (per requirements).
          return widget.localeController.locale;
        },
        initialRoute: '/home',
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/addItem': (context) => RequireAuth(child: AddItemScreen(), nextRoute: '/addItem'),
          '/auth': (context) => AuthScreen(),
          '/itemDetail': (context) => ItemDetailScreen(item: ModalRoute.of(context)!.settings.arguments as Item),
          '/chat': (context) => RequireAuth(child: ChatScreen(), nextRoute: '/chat'),
          '/claimedItems': (context) => RequireAuth(child: ClaimedItemsScreen(), nextRoute: '/claimedItems'),
          '/rewardPayment': (context) => RequireAuth(child: RewardPaymentScreen(), nextRoute: '/rewardPayment'),
        },
      ),
    );
  }
}

class RequireAuth extends StatefulWidget {
  const RequireAuth({
    super.key,
    required this.child,
    required this.nextRoute,
    this.nextArgs,
  });

  final Widget child;
  final String nextRoute;
  final Object? nextArgs;

  @override
  State<RequireAuth> createState() => _RequireAuthState();
}

class _RequireAuthState extends State<RequireAuth> {
  bool _redirecting = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null && !_redirecting) {
      _redirecting = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          '/login',
          arguments: {'next': widget.nextRoute, 'nextArgs': widget.nextArgs},
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return widget.child;
  }
}
