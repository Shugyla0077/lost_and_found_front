// lib/services/auth_service.dart
abstract class AuthService {
  Future<bool> login(String username, String password);
  Future<bool> register(String username, String password);
}

class AuthServiceImpl implements AuthService {
  @override
  Future<bool> login(String username, String password) async {
    // Логика для логина (в реальном приложении сюда добавляем вызовы API)
    await Future.delayed(Duration(seconds: 1)); // имитация задержки
    return username == 'user' && password == 'password'; // Пример успешного логина
  }

  @override
  Future<bool> register(String username, String password) async {
    // Логика для регистрации
    await Future.delayed(Duration(seconds: 1)); // имитация задержки
    return true;
  }
}