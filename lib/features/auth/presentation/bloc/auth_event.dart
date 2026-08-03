import 'package:equatable/equatable.dart';
import 'package:personal_fitness_tracker/features/auth/domain/entities/user_entities.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

//        Session                                                                                                                          

class AuthSessionRestoreRequested extends AuthEvent {
  const AuthSessionRestoreRequested();
}

class AuthSessionChanged extends AuthEvent {
  final UserEntity? user;

  const AuthSessionChanged({required this.user});

  @override
  List<Object?> get props => [user];
}

//        Auth action events                                                                                                               

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class AuthSignUpEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;

  const AuthSignUpEvent({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [username, email, password];
}

class AuthForgotPasswordEvent extends AuthEvent {
  final String email;

  const AuthForgotPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthSignOutEvent extends AuthEvent {
  const AuthSignOutEvent();
}
