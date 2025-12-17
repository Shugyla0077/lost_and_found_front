import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthService {
  Future<UserCredential> login(String email, String password);
  Future<UserCredential> register(String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<void> logout();
}

class AuthServiceImpl implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<UserCredential> login(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<UserCredential> register(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> logout() {
    return _auth.signOut();
  }
}
