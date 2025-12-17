// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Lost & Found';

  @override
  String get home => 'Home';

  @override
  String get chats => 'Chats';

  @override
  String get myItems => 'My Items';

  @override
  String get profile => 'Profile';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String loginFailed(Object error) {
    return 'Login failed: $error';
  }

  @override
  String registrationFailed(Object error) {
    return 'Registration failed: $error';
  }

  @override
  String get noAccountRegister => 'Don\'t have an account? Register here';

  @override
  String get addItem => 'Add Item';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String get location => 'Location';

  @override
  String addItemFailed(Object error) {
    return 'Failed to add item: $error';
  }

  @override
  String get contactPrivateAddItemHint =>
      'Your contact will remain private. Owners can contact you through chat after claiming.';

  @override
  String get noItemsYet => 'No items yet. Add the first one!';

  @override
  String get noMyItemsYetTitle => 'No items yet';

  @override
  String get noMyItemsYetSubtitle => 'Add your first found item';

  @override
  String failedToLoadItems(Object error) {
    return 'Failed to load items: $error';
  }

  @override
  String get claimed => 'Claimed';

  @override
  String get available => 'Available';

  @override
  String get waitingForOwner => 'Waiting for owner';

  @override
  String get contactsPrivate =>
      'Contacts are kept private. Use chat to communicate.';

  @override
  String get claimYourItemHint =>
      'Is this your item? Claim it to start chatting with the finder.';

  @override
  String get claimThisItem => 'Claim this item';

  @override
  String get openChat => 'Open Chat';

  @override
  String get alreadyClaimed => 'Already claimed';

  @override
  String get ownItemBanner => 'This item was added by you';

  @override
  String get cannotClaimOwnItem => 'You can\'t claim your own item.';

  @override
  String get itemClaimed => 'Item claimed! You can now chat with the finder.';

  @override
  String failedToClaim(Object error) {
    return 'Failed to claim: $error';
  }

  @override
  String failedToLoadChats(Object error) {
    return 'Failed to load chats: $error';
  }

  @override
  String get noChatsYet => 'No chats yet';

  @override
  String get claimItemToStartChatting => 'Claim an item to start chatting';

  @override
  String failedToLoadMessages(Object error) {
    return 'Failed to load messages: $error';
  }

  @override
  String failedToSendMessage(Object error) {
    return 'Failed to send message: $error';
  }

  @override
  String get noMessagesYet => 'No messages yet. Start the conversation!';

  @override
  String get noMessagesYetShort => 'No messages yet';

  @override
  String get typeMessageHint => 'Type a message...';

  @override
  String timeDaysAgo(Object days) {
    return '${days}d ago';
  }

  @override
  String timeHoursAgo(Object hours) {
    return '${hours}h ago';
  }

  @override
  String timeMinutesAgo(Object minutes) {
    return '${minutes}m ago';
  }

  @override
  String get timeJustNow => 'Just now';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get notAuthenticated => 'Not authenticated. Please sign in.';

  @override
  String failedToLoadProfile(Object error) {
    return 'Failed to load profile: $error';
  }

  @override
  String failedToSaveProfile(Object error) {
    return 'Failed to save profile: $error';
  }

  @override
  String get account => 'Account';

  @override
  String get uid => 'UID';

  @override
  String get profileSection => 'Profile';

  @override
  String get displayName => 'Display name';

  @override
  String get city => 'City';

  @override
  String get about => 'About';

  @override
  String get save => 'Save';

  @override
  String get logout => 'Logout';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get russian => 'Russian';

  @override
  String get kazakh => 'Kazakh';
}
