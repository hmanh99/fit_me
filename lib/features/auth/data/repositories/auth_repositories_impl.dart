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
  UserEntity? get currentUser {
    final user = _authService.user;
    if (user == null) return null;
    return UserModel.fromJson(user);
  }

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
      return UserModel.fromJson(user, username: username);
    } on AuthException {
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
      return UserModel.fromJson(user);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(message: 'An unexpected error occurred during login.');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _authService.signOut();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(message: 'An unexpected error occurred during sign-out.');
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await _authService.forgotPassword(email: email);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(
          message: 'An unexpected error occurred while sending reset email.');
    }
  }

  // @override
  // Future<UserEntity> googleLogin() async {}
}