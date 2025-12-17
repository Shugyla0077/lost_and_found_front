import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
        theme: ThemeData(primarySwatch: Colors.blue),
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
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/addItem': (context) => AddItemScreen(),
          '/auth': (context) => AuthScreen(),
          '/itemDetail': (context) => ItemDetailScreen(item: ModalRoute.of(context)!.settings.arguments as Item),
          '/chat': (context) => ChatScreen(), // ChatScreen route
          '/claimedItems': (context) => const ClaimedItemsScreen(),
          '/rewardPayment': (context) => const RewardPaymentScreen(),
        },
      ),
    );
  }
}
