// lib/utils/injector.dart
import 'package:get_it/get_it.dart';
import '../services/auth_service.dart';
import '../services/item_service.dart';
import '../services/chat_service.dart';
import '../services/profile_service.dart';
import '../services/api_client.dart';
import '../utils/locale_controller.dart';

final GetIt getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<AuthService>(() => AuthServiceImpl());
  getIt.registerLazySingleton<ItemService>(
    () => ItemServiceImpl(createBackendDio()),
  );
  getIt.registerLazySingleton<ChatService>(
    () => ChatServiceImpl(createBackendDio()),
  );
  getIt.registerLazySingleton<ProfileService>(
    () => ProfileServiceImpl(createBackendDio()),
  );
  getIt.registerLazySingleton<LocaleController>(() => LocaleController());
}
