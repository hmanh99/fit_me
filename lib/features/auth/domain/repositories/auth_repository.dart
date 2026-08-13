import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/features/auth/domain/entities/user_entities.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity?>> currentUser();

  // Sign in with email and password.
  Future<Either<Failure,UserEntity>> login({
    required String email,
    required String password,
  });

  // Sign up with username, email, and password.
  Future<Either<Failure,UserEntity>> signUp({
    required String username,
    required String email,
    required String password,
  });

  // Send a password-reset email.
  Future<Either<Failure,void>> forgotPassword({required String email});

  // Sign out the current user.
  Future<Either<Failure,void>> logout();

  // Emits the current user whenever the Supabase auth session changes.
  Stream<Either<Failure,UserEntity?>> watchAuthState();

}