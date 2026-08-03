import 'package:equatable/equatable.dart';
import 'package:personal_fitness_tracker/features/auth/domain/entities/user_entities.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Session chưa xác định (đang restore từ Firebase / repositories).
class AuthUnknownState extends AuthState {
  const AuthUnknownState();
}

/// User đã đăng nhập (dùng cho redirect / guard).
abstract class AuthAuthenticatedState extends AuthState {
  const AuthAuthenticatedState();
}

//     Initial (guest — ví dụ welcome / onboarding entry)

class AuthInitialState extends AuthState {
  const AuthInitialState();
}

//     Loading                                                                  

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

//     Sign-in / Sign-up success                                                

class AuthLoginState extends AuthAuthenticatedState {
  // FIX: changed UserModel → UserEntity (domain states must depend on
  //      domain types only, never on data-layer models).
  final UserEntity user;

  const AuthLoginState({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthSignUpState extends AuthAuthenticatedState {
  final UserEntity user; // FIX: same as above

  const AuthSignUpState({required this.user});

  @override
  List<Object?> get props => [user];
}

//     Forgot password                                                          

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