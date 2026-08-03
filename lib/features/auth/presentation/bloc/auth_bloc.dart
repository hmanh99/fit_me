import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:personal_fitness_tracker/features/auth/domain/repositories/auth_repository.dart';
import 'package:personal_fitness_tracker/features/auth/domain/entities/user_entities.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late final StreamSubscription<UserEntity?> _authStateSubscription;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthUnknownState()) {
    _authStateSubscription = _authRepository.watchAuthState().listen((user) {
      add(AuthSessionChanged(user: user));
    });

    on<AuthSessionRestoreRequested>((event, emit) {
      final user = _authRepository.currentUser;
      if (user != null) {
        emit(AuthLoginState(user: user));
      } else {
        emit(const AuthInitialState());
      }
    });

    on<AuthSessionChanged>((event, emit) {
      if (state is AuthLoadingState) return;

      if (event.user == null) {
        if (state is! AuthSignOutState) {
          emit(const AuthSignOutState());
        }
        return;
      }

      final user = event.user!;
      final currentState = state;
      if (currentState is AuthLoginState &&
          currentState.user.id == user.id) {
        return;
      }
      if (currentState is AuthSignUpState &&
          currentState.user.id == user.id) {
        return;
      }
      emit(AuthLoginState(user: user));
    });

    ///handle sign up
    on<AuthSignUpEvent>((event, emit) async {
      emit(const AuthLoadingState());
      try {
        final user = await _authRepository.signUp(
          username: event.username,
          email: event.email,
          password: event.password,
        );

        emit(AuthSignUpState(user: user));
      } catch (e) {
        emit(AuthErrorState(message: e.toString()));
      }
    });

    ///handle sign in
    on<AuthLoginEvent>((event, emit) async {
      emit(const AuthLoadingState());
      try {
        final user = await _authRepository.login(
          email: event.email,
          password: event.password,
        );
        emit(AuthLoginState(user: user));
      } catch (e) {
        emit(AuthErrorState(message: e.toString()));
      }
    });

    ///hande sign out
    on<AuthSignOutEvent>((event, emit) async {
      emit(const AuthLoadingState());
      try {
        await _authRepository.logout();
        emit(const AuthSignOutState());
      } catch (e) {
        emit(AuthErrorState(message: e.toString()));
      }
    });

    ///handle forgot password
    on<AuthForgotPasswordEvent>((event, emit) async {
      emit(const AuthLoadingState());
      try {
        await _authRepository.forgotPassword(email: event.email);
        emit(const AuthForgotPasswordSuccessState());
      } catch (e) {
        emit(AuthErrorState(message: e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }
}
