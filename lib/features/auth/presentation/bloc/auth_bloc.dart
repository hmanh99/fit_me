import 'package:bloc/bloc.dart';
import 'package:personal_fitness_tracker/features/auth/domain/repositories/auth_repositories.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_event.dart';
import 'package:personal_fitness_tracker/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthInitialState()) {
    ///handle sign up needed
    on<AuthSignUpNeededEvent>((event, emit) {
      emit(const AuthSignUpNeededState());
    },);

    ///handle sign in needed
    on<AuthSignInNeededEvent>((event, emit) {
      emit(const AuthSignInNeededState());
    },);

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
    on<AuthSignInEvent>((event, emit) async {
      emit(const AuthLoadingState());
      try {
        final user = await _authRepository.login(
          email: event.email,
          password: event.password,
        );
        emit(AuthSignInState(user: user));
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

    ///handle forgot pass word needed
    on<AuthForgotPasswordNeededEvent>((event, emit) {
      emit(const AuthForgotPasswordNeededState());
    },);

    ///handle forgot password
    on<AuthForgotPasswordEvent>((event, emit) async {
      emit(const AuthLoadingState());
      try{
        await _authRepository.forgotPassword(email: event.email);
        emit(const AuthForgotPasswordSuccessState());
      } catch (e){
        emit(AuthErrorState(message: e.toString()));
      }
    });

  }
}
