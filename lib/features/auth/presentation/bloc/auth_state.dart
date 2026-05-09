import 'package:equatable/equatable.dart';
import 'package:personal_fitness_tracker/features/auth/domain/entities/user_entities.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

//     Initial                                                                 

class AuthInitialState extends AuthState {
  const AuthInitialState();
}

//     Loading                                                                  

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

//     Navigation triggers                                                      

class AuthSignUpNeededState extends AuthState {
  const AuthSignUpNeededState();
}

class AuthSignInNeededState extends AuthState {
  const AuthSignInNeededState();
}

//     Sign-in / Sign-up success                                                

class AuthSignInState extends AuthState {
  // FIX: changed UserModel → UserEntity (domain states must depend on
  //      domain types only, never on data-layer models).
  final UserEntity user;

  const AuthSignInState({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthSignUpState extends AuthState {
  final UserEntity user; // FIX: same as above

  const AuthSignUpState({required this.user});

  @override
  List<Object?> get props => [user];
}

//     Forgot password                                                          

class AuthForgotPasswordNeededState extends AuthState {
  const AuthForgotPasswordNeededState();
}

// FIX: Removed unused AuthForgotPasswordState — it was dead code that could
//      be confused with AuthForgotPasswordSuccessState by future developers.

class AuthForgotPasswordSuccessState extends AuthState {
  const AuthForgotPasswordSuccessState();
}

//     Sign-out                                                                 

class AuthSignOutState extends AuthState {
  const AuthSignOutState();
}

//     Error                                                                    

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}