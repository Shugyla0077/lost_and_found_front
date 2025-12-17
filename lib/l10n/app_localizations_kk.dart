// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class AppLocalizationsKk extends AppLocalizations {
  AppLocalizationsKk([String locale = 'kk']) : super(locale);

  @override
  String get appTitle => 'Табылған заттар';

  @override
  String get home => 'Басты бет';

  @override
  String get chats => 'Чаттар';

  @override
  String get myItems => 'Менің заттарым';

  @override
  String get profile => 'Профиль';

  @override
  String get login => 'Кіру';

  @override
  String get register => 'Тіркелу';

  @override
  String get email => 'Email';

  @override
  String get password => 'Құпиясөз';

  @override
  String loginFailed(Object error) {
    return 'Кіру сәтсіз болды: $error';
  }

  @override
  String registrationFailed(Object error) {
    return 'Тіркелу сәтсіз болды: $error';
  }

  @override
  String get noAccountRegister => 'Аккаунт жоқ па? Тіркеліңіз';

  @override
  String get addItem => 'Зат қосу';

  @override
  String get title => 'Атауы';

  @override
  String get description => 'Сипаттама';

  @override
  String get location => 'Орны';

  @override
  String addItemFailed(Object error) {
    return 'Затты қосу мүмкін болмады: $error';
  }

  @override
  String get contactPrivateAddItemHint =>
      'Байланыс деректеріңіз құпия сақталады. Иесі өтініш жібергеннен кейін чат арқылы хабарласа алады.';

  @override
  String get noItemsYet => 'Әзірге заттар жоқ. Біріншісін қосыңыз!';

  @override
  String get noMyItemsYetTitle => 'Заттар жоқ';

  @override
  String get noMyItemsYetSubtitle => 'Бірінші табылған затыңызды қосыңыз';

  @override
  String failedToLoadItems(Object error) {
    return 'Заттарды жүктеу мүмкін болмады: $error';
  }

  @override
  String get claimed => 'Алынды';

  @override
  String get available => 'Қолжетімді';

  @override
  String get waitingForOwner => 'Иесін күтіп тұр';

  @override
  String get contactsPrivate =>
      'Байланыс деректері жасырылған. Хабарласу үшін чатты пайдаланыңыз.';

  @override
  String get claimYourItemHint =>
      'Бұл сіздің затыңыз ба? Табушыға жазу үшін өтініш жіберіңіз.';

  @override
  String get claimThisItem => 'Өтініш жіберу';

  @override
  String get openChat => 'Чатты ашу';

  @override
  String get alreadyClaimed => 'Бұрын алынған';

  @override
  String get ownItemBanner => 'Бұл затты сіз қостыңыз';

  @override
  String get cannotClaimOwnItem =>
      'Өзіңіздің затыңызға өтініш жіберуге болмайды.';

  @override
  String get itemClaimed => 'Өтініш жіберілді! Енді чатта жаза аласыз.';

  @override
  String failedToClaim(Object error) {
    return 'Өтініш жіберу мүмкін болмады: $error';
  }

  @override
  String failedToLoadChats(Object error) {
    return 'Чаттарды жүктеу мүмкін болмады: $error';
  }

  @override
  String get noChatsYet => 'Әзірге чат жоқ';

  @override
  String get claimItemToStartChatting =>
      'Чат бастау үшін затқа өтініш жіберіңіз';

  @override
  String failedToLoadMessages(Object error) {
    return 'Хабарламаларды жүктеу мүмкін болмады: $error';
  }

  @override
  String failedToSendMessage(Object error) {
    return 'Хабарлама жіберу мүмкін болмады: $error';
  }

  @override
  String get noMessagesYet => 'Хабарламалар жоқ. Диалогты бастаңыз!';

  @override
  String get noMessagesYetShort => 'Хабарлама жоқ';

  @override
  String get typeMessageHint => 'Хабарлама жазыңыз...';

  @override
  String timeDaysAgo(Object days) {
    return '$days күн бұрын';
  }

  @override
  String timeHoursAgo(Object hours) {
    return '$hours сағ бұрын';
  }

  @override
  String timeMinutesAgo(Object minutes) {
    return '$minutes мин бұрын';
  }

  @override
  String get timeJustNow => 'Қазір ғана';

  @override
  String get profileSaved => 'Профиль сақталды';

  @override
  String get notAuthenticated => 'Авторизация жоқ. Қайта кіріңіз.';

  @override
  String failedToLoadProfile(Object error) {
    return 'Профильді жүктеу мүмкін болмады: $error';
  }

  @override
  String failedToSaveProfile(Object error) {
    return 'Профильді сақтау мүмкін болмады: $error';
  }

  @override
  String get account => 'Аккаунт';

  @override
  String get uid => 'UID';

  @override
  String get profileSection => 'Профиль';

  @override
  String get displayName => 'Аты';

  @override
  String get city => 'Қала';

  @override
  String get about => 'Өзі туралы';

  @override
  String get save => 'Сақтау';

  @override
  String get logout => 'Шығу';

  @override
  String get language => 'Тіл';

  @override
  String get english => 'Ағылшын';

  @override
  String get russian => 'Орысша';

  @override
  String get kazakh => 'Қазақша';
}
