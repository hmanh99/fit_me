import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

//        Navigation events                                                                                                                 

class AuthSignUpNeededEvent extends AuthEvent {
  const AuthSignUpNeededEvent();
}

class AuthSignInNeededEvent extends AuthEvent {
  const AuthSignInNeededEvent();
}

class AuthForgotPasswordNeededEvent extends AuthEvent {
  const AuthForgotPasswordNeededEvent();
}

//        Auth action events                                                                                                               

class AuthSignInEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInEvent({
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
