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
  String get forgotPassword => 'Құпиясөзді ұмыттыңыз ба?';

  @override
  String get resetPassword => 'Құпиясөзді қалпына келтіру';

  @override
  String get resetPasswordHint =>
      'Email енгізіңіз — біз қалпына келтіру сілтемесін жібереміз.';

  @override
  String get sendResetLink => 'Сілтемені жіберу';

  @override
  String get emailRequired => 'Email міндетті';

  @override
  String get passwordResetEmailSent =>
      'Қалпына келтіру хаты жіберілді. Поштаны тексеріңіз.';

  @override
  String passwordResetFailed(Object error) {
    return 'Хатты жіберу мүмкін болмады: $error';
  }

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
  String get chatAccessDenied => 'Бұл чатқа қолжетімділік жоқ.';

  @override
  String get chatAccessDeniedHint =>
      'Тек табушы мен өтініш берген адам ғана осы зат бойынша жаза алады.';

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
  String get edit => 'Өзгерту';

  @override
  String get cancel => 'Бас тарту';

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

  @override
  String get category => 'Санат';

  @override
  String get filters => 'Сүзгілер';

  @override
  String get resetFilters => 'Тазалау';

  @override
  String get applyFilters => 'Қолдану';

  @override
  String get clear => 'Тазарту';

  @override
  String get allCategories => 'Барлық санаттар';

  @override
  String get dateFrom => 'Бастап';

  @override
  String get dateTo => 'Дейін';

  @override
  String get noItemsMatchFilter => 'Сүзгіге сәйкес заттар жоқ';

  @override
  String get titleRequired => 'Атауы міндетті';

  @override
  String get claimedItems => 'Алынған заттар';

  @override
  String get viewClaimedItems => 'Алынған заттар тізімін ашу';

  @override
  String get noClaimedItemsYet => 'Әзірге алынған заттар жоқ';

  @override
  String failedToLoadClaimedItems(Object error) {
    return 'Алынған заттарды жүктеу мүмкін болмады: $error';
  }

  @override
  String get rewardPayment => 'Сыйақы төлеу';

  @override
  String get rewardPaymentSubtitle => 'Төлеу үшін Stripe Checkout ашу';

  @override
  String get chooseAmount => 'Соманы таңдаңыз';

  @override
  String amountUsd(Object amount) {
    return '$amount USD';
  }

  @override
  String get customAmountUsd => 'Өз сомаңыз (USD)';

  @override
  String get pay => 'Төлеу';

  @override
  String get invalidAmount => 'Дұрыс соманы енгізіңіз';

  @override
  String amountRange(Object max, Object min) {
    return 'Рұқсат етілгені: $min..$max USD';
  }

  @override
  String get failedToOpenCheckout => 'Stripe Checkout ашу мүмкін болмады';

  @override
  String paymentFailed(Object error) {
    return 'Төлем қатесі: $error';
  }

  @override
  String get paymentThanks => 'Төлеміңізге рақмет!';

  @override
  String get paymentCanceled => 'Төлем тоқтатылды';
}
