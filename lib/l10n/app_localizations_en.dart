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
  String get forgotPassword => 'Forgot password?';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get resetPasswordHint =>
      'Enter your email and we’ll send a reset link.';

  @override
  String get sendResetLink => 'Send link';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get passwordResetEmailSent => 'Reset email sent. Check your inbox.';

  @override
  String passwordResetFailed(Object error) {
    return 'Failed to send reset email: $error';
  }

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
  String get edit => 'Edit';

  @override
  String get cancel => 'Cancel';

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

  @override
  String get category => 'Category';

  @override
  String get filters => 'Filters';

  @override
  String get resetFilters => 'Reset';

  @override
  String get applyFilters => 'Apply';

  @override
  String get clear => 'Clear';

  @override
  String get allCategories => 'All categories';

  @override
  String get dateFrom => 'From';

  @override
  String get dateTo => 'To';

  @override
  String get noItemsMatchFilter => 'No items match your filters';

  @override
  String get titleRequired => 'Title is required';

  @override
  String get claimedItems => 'Claimed items';

  @override
  String get viewClaimedItems => 'View your claimed items list';

  @override
  String get noClaimedItemsYet => 'No claimed items yet';

  @override
  String failedToLoadClaimedItems(Object error) {
    return 'Failed to load claimed items: $error';
  }

  @override
  String get rewardPayment => 'Reward payment';

  @override
  String get rewardPaymentSubtitle => 'Open Stripe Checkout to pay a reward';

  @override
  String get chooseAmount => 'Choose amount';

  @override
  String amountUsd(Object amount) {
    return '$amount USD';
  }

  @override
  String get customAmountUsd => 'Custom amount (USD)';

  @override
  String get pay => 'Pay';

  @override
  String get invalidAmount => 'Enter a valid amount';

  @override
  String amountRange(Object max, Object min) {
    return 'Allowed range: $min..$max USD';
  }

  @override
  String get failedToOpenCheckout => 'Failed to open Stripe Checkout';

  @override
  String paymentFailed(Object error) {
    return 'Payment failed: $error';
  }

  @override
  String get paymentThanks => 'Thanks for your payment!';

  @override
  String get paymentCanceled => 'Payment canceled';
}
