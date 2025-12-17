import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../services/profile_service.dart';

class LocaleController extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  String get languageCode => _locale.languageCode;

  void setLanguage(String languageCode) {
    final next = Locale(languageCode);
    if (next == _locale) return;
    _locale = next;
    notifyListeners();
  }

  Future<void> loadInitial() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setLanguage('en');
      return;
    }

    try {
      final profileService = GetIt.I<ProfileService>();
      final profile = await profileService.getProfile();
      final code = profile.language.isEmpty ? 'en' : profile.language;
      setLanguage(code);
    } catch (_) {
      setLanguage('en');
    }
  }
}

