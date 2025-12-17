// lib/utils/injector.dart
import 'package:get_it/get_it.dart';
import '../services/auth_service.dart';
import '../services/item_service.dart';
import '../services/chat_service.dart';
import '../services/api_client.dart';

final GetIt getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<AuthService>(() => AuthServiceImpl());
  getIt.registerLazySingleton<ItemService>(
    () => ItemServiceImpl(createBackendDio()),
  );
  getIt.registerLazySingleton<ChatService>(
    () => ChatServiceImpl(createBackendDio()),
  );
}
