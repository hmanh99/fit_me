import 'package:personal_fitness_tracker/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

class AuthService {
  AuthService._();
  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;

  SupabaseClient get _client => Supabase.instance.client;

  User? get user => _client.auth.currentUser;

  Stream<User?> get authStateChanges =>
      _client.auth.onAuthStateChange.map((event) => event.session?.user);

  Future<User> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _client.auth.signUp(
        email: email.trim(),
        password: password.trim(),
        data: {'username': username},
      );

      final User? user = response.user;
      if (user == null) {
        throw AuthException(message: 'Sign-up failed: no user returned.');
      }

      return user;
    } on AuthException {
      rethrow;
    } on AuthApiException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  Future<User> signIn({required String email, required String password}) async {
    try {
      final AuthResponse response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final User? user = response.user;
      if (user == null) {
        throw AuthException(message: 'User not found.');
      }

      return user;
    } on AuthException {
      rethrow;
    } on AuthApiException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthApiException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      await _client.auth.resetPasswordForEmail(email.trim());
    } on AuthApiException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  // Future<User?> signInWithGoogle() async {}
}
