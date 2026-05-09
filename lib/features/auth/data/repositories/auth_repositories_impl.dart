import 'package:personal_fitness_tracker/core/error/exceptions.dart';
import 'package:personal_fitness_tracker/core/services/auth_services.dart';
import 'package:personal_fitness_tracker/features/auth/domain/entities/user_entities.dart';
import 'package:personal_fitness_tracker/features/auth/domain/repositories/auth_repositories.dart';
import 'package:personal_fitness_tracker/features/auth/data/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl({AuthService? authService})
      : _authService = authService ?? AuthService();

  @override
  Future<UserEntity> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final user = await _authService.signUp(
        email: email,
        password: password,
        username: username,
      );
      return UserModel.fromFirebaseUser(user, username: username);
    } on AuthException catch (e) {
      rethrow;
    } catch (e) {
      throw AuthException(message: 'An unexpected error occurred during sign-up.');
    }
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _authService.signIn(email: email, password: password);
      if (user == null) {
        throw AuthException(message: 'Login failed. Please check your credentials.');
      }
      return UserModel.fromFirebaseUser(user);
    } on AuthException catch (e) {
      rethrow;
    } catch (e) {
      throw AuthException(message: 'An unexpected error occurred during login.');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _authService.signOut();
    } on AuthException catch (e) {
      rethrow;
    } catch (e) {
      throw AuthException(message: 'An unexpected error occurred during sign-out.');
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await _authService.forgotPassword(email: email);
    } on AuthException catch (e) {
      rethrow;
    } catch (e) {
      throw AuthException(message: 'An unexpected error occurred while sending reset email.');
    }
  }

  @override
  Future<UserEntity> googleLogin() async {
    try {
      final user = await _authService.signInWithGoogle();
      if (user == null) {
        throw AuthException(message: 'Google Sign-in was cancelled.');
      }
      return UserModel.fromFirebaseUser(user);
    } on AuthException catch (e) {
      rethrow;
    } catch (e) {
      throw AuthException(message: 'An unexpected error occurred during Google Sign-in.');
    }
  }
}