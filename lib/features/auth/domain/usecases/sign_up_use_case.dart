import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/features/auth/domain/entities/user_entities.dart';
import 'package:fit_me/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/usecase/usecase.dart';


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

class SignUpUseCase implements UseCase<UserEntity, SignUpUseCaseParams>{
  final AuthRepository repository;

  const SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignUpUseCaseParams params) async {
    return await repository.signUp(
      username: params.username,
      email: params.email,
      password: params.password,
    );
  }
}
