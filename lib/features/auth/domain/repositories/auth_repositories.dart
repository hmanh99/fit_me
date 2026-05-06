import 'package:personal_fitness_tracker/features/auth/domain/entities/user_entities.dart';

abstract class AuthRepository {
  /// Sign in with email and password
  Future<UserModel> login({
    required String email,
    required String password,
  });

  /// Sign up with email, password, and optional name
  Future<UserModel> signUp({
    required String username,
    required String email,
    required String password,
  });

  /// Send a password reset email
  Future<void> forgotPassword({
    required String email,
  });

  /// Sign out the current user
  Future<void> logout();
}