import 'package:firebase_auth/firebase_auth.dart';
import '../provider/firebase_auth_provider.dart';

class AuthRepository {
  final FirebaseAuthProvider provider;

  AuthRepository(this.provider);

  Future<User?> login(String email, String password) =>
      provider.signIn(email, password);

  Future<User?> register(String email, String password) =>
      provider.register(email, password);

  Future<void> logout() => provider.logout();

  Stream<User?> get userStream => provider.userStream;
}
