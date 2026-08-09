import 'package:personal_fitness_tracker/features/auth/domain/entities/user_entities.dart';
import 'package:personal_fitness_tracker/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCaseParams {
  final String username;
  final String email;
  final String password;

  const SignUpUseCaseParams({
    required this.username,
    required this.email,
    required this.password,
  });
}

class SignUpUseCase {
  final AuthRepository repository;

  const SignUpUseCase(this.repository);

  Future<UserEntity> call(SignUpUseCaseParams params) {
    return repository.signUp(
      username: params.username,
      email: params.email,
      password: params.password,
    );
  }
}
