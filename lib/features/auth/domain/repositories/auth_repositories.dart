import 'package:personal_fitness_tracker/features/auth/domain/entities/user_entities.dart';

abstract class AuthRepository {
  /// User hiện tại (Firebase session), hoặc `null` nếu chưa đăng nhập.
  UserEntity? get currentUser;

  /// Sign in with email and password.
  Future<UserEntity> login({
    required String email,
    required String password,
  });

  /// Sign up with username, email, and password.
  Future<UserEntity> signUp({
    required String username,
    required String email,
    required String password,
  });

  /// Send a password-reset email.
  Future<void> forgotPassword({required String email});

  /// Sign out the current user.
  Future<void> logout();

  /// Sign in with Google.
  Future<UserEntity> googleLogin();
}