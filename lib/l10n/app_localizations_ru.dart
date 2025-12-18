// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Бюро находок';

  @override
  String get home => 'Главная';

  @override
  String get chats => 'Чаты';

  @override
  String get myItems => 'Мои вещи';

  @override
  String get profile => 'Профиль';

  @override
  String get login => 'Вход';

  @override
  String get register => 'Регистрация';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String loginFailed(Object error) {
    return 'Не удалось войти: $error';
  }

  @override
  String registrationFailed(Object error) {
    return 'Не удалось зарегистрироваться: $error';
  }

  @override
  String get noAccountRegister => 'Нет аккаунта? Зарегистрируйтесь';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get resetPassword => 'Сброс пароля';

  @override
  String get resetPasswordHint =>
      'Введите email — мы отправим ссылку для сброса пароля.';

  @override
  String get sendResetLink => 'Отправить ссылку';

  @override
  String get emailRequired => 'Email обязателен';

  @override
  String get passwordResetEmailSent =>
      'Письмо для сброса отправлено. Проверьте почту.';

  @override
  String passwordResetFailed(Object error) {
    return 'Не удалось отправить письмо: $error';
  }

  @override
  String get addItem => 'Добавить вещь';

  @override
  String get title => 'Название';

  @override
  String get description => 'Описание';

  @override
  String get location => 'Место';

  @override
  String addItemFailed(Object error) {
    return 'Не удалось добавить вещь: $error';
  }

  @override
  String get contactPrivateAddItemHint =>
      'Ваши контакты останутся скрытыми. Владелец сможет связаться с вами через чат после заявки.';

  @override
  String get noItemsYet => 'Пока нет вещей. Добавьте первую!';

  @override
  String get noMyItemsYetTitle => 'Нет вещей';

  @override
  String get noMyItemsYetSubtitle => 'Добавьте свою первую найденную вещь';

  @override
  String failedToLoadItems(Object error) {
    return 'Не удалось загрузить вещи: $error';
  }

  @override
  String get claimed => 'Забрано';

  @override
  String get available => 'Доступно';

  @override
  String get waitingForOwner => 'Ожидает владельца';

  @override
  String get contactsPrivate => 'Контакты скрыты. Используйте чат для общения.';

  @override
  String get claimYourItemHint =>
      'Это ваша вещь? Отправьте заявку, чтобы начать чат с нашедшим.';

  @override
  String get claimThisItem => 'Отправить заявку';

  @override
  String get openChat => 'Открыть чат';

  @override
  String get alreadyClaimed => 'Уже забрано';

  @override
  String get ownItemBanner => 'Этот предмет вы добавили';

  @override
  String get cannotClaimOwnItem => 'Нельзя отправить заявку на свой предмет.';

  @override
  String get itemClaimed => 'Заявка отправлена! Теперь можно писать в чат.';

  @override
  String failedToClaim(Object error) {
    return 'Не удалось отправить заявку: $error';
  }

  @override
  String failedToLoadChats(Object error) {
    return 'Не удалось загрузить чаты: $error';
  }

  @override
  String get noChatsYet => 'Чатов пока нет';

  @override
  String get claimItemToStartChatting =>
      'Отправьте заявку на вещь, чтобы начать чат';

  @override
  String failedToLoadMessages(Object error) {
    return 'Не удалось загрузить сообщения: $error';
  }

  @override
  String failedToSendMessage(Object error) {
    return 'Не удалось отправить сообщение: $error';
  }

  @override
  String get chatAccessDenied => 'У вас нет доступа к этому чату.';

  @override
  String get chatAccessDeniedHint =>
      'Только табушы и заявитель могут переписываться по этому предмету.';

  @override
  String get noMessagesYet => 'Сообщений пока нет. Начните диалог!';

  @override
  String get noMessagesYetShort => 'Сообщений нет';

  @override
  String get typeMessageHint => 'Введите сообщение...';

  @override
  String timeDaysAgo(Object days) {
    return '$daysд назад';
  }

  @override
  String timeHoursAgo(Object hours) {
    return '$hoursч назад';
  }

  @override
  String timeMinutesAgo(Object minutes) {
    return '$minutesм назад';
  }

  @override
  String get timeJustNow => 'Только что';

  @override
  String get profileSaved => 'Профиль сохранён';

  @override
  String get notAuthenticated => 'Вы не авторизованы. Пожалуйста, войдите.';

  @override
  String failedToLoadProfile(Object error) {
    return 'Не удалось загрузить профиль: $error';
  }

  @override
  String failedToSaveProfile(Object error) {
    return 'Не удалось сохранить профиль: $error';
  }

  @override
  String get account => 'Аккаунт';

  @override
  String get uid => 'UID';

  @override
  String get profileSection => 'Профиль';

  @override
  String get displayName => 'Имя';

  @override
  String get city => 'Город';

  @override
  String get about => 'О себе';

  @override
  String get save => 'Сохранить';

  @override
  String get edit => 'Изменить';

  @override
  String get cancel => 'Отмена';

  @override
  String get logout => 'Выйти';

  @override
  String get language => 'Язык';

  @override
  String get english => 'Английский';

  @override
  String get russian => 'Русский';

  @override
  String get kazakh => 'Казахский';

  @override
  String get category => 'Категория';

  @override
  String get filters => 'Фильтры';

  @override
  String get resetFilters => 'Сбросить';

  @override
  String get applyFilters => 'Применить';

  @override
  String get clear => 'Очистить';

  @override
  String get allCategories => 'Все категории';

  @override
  String get dateFrom => 'От';

  @override
  String get dateTo => 'До';

  @override
  String get noItemsMatchFilter => 'Нет вещей по заданным фильтрам';

  @override
  String get titleRequired => 'Название обязательно';

  @override
  String get claimedItems => 'Забранные вещи';

  @override
  String get viewClaimedItems => 'Открыть список забранных вещей';

  @override
  String get noClaimedItemsYet => 'Забранных вещей пока нет';

  @override
  String failedToLoadClaimedItems(Object error) {
    return 'Не удалось загрузить забранные вещи: $error';
  }

  @override
  String get rewardPayment => 'Оплата вознаграждения';

  @override
  String get rewardPaymentSubtitle => 'Открыть Stripe Checkout для оплаты';

  @override
  String get chooseAmount => 'Выберите сумму';

  @override
  String amountUsd(Object amount) {
    return '$amount USD';
  }

  @override
  String get customAmountUsd => 'Своя сумма (USD)';

  @override
  String get pay => 'Оплатить';

  @override
  String get invalidAmount => 'Введите корректную сумму';

  @override
  String amountRange(Object max, Object min) {
    return 'Допустимо: $min..$max USD';
  }

  @override
  String get failedToOpenCheckout => 'Не удалось открыть Stripe Checkout';

  @override
  String paymentFailed(Object error) {
    return 'Ошибка оплаты: $error';
  }

  @override
  String get paymentThanks => 'Спасибо за оплату!';

  @override
  String get paymentCanceled => 'Оплата отменена';
}
