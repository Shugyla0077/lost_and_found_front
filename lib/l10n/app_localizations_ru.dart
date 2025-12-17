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
  String get logout => 'Выйти';

  @override
  String get language => 'Язык';

  @override
  String get english => 'Английский';

  @override
  String get russian => 'Русский';

  @override
  String get kazakh => 'Казахский';
}
