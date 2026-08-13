import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class ForgotPasswordUseCase implements UseCase<void, ForgotPasswordParams> {
  final AuthRepository repository;

  const ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) async {
    return await repository.forgotPassword(email: params.email);
  }
}

class ForgotPasswordParams {
  final String email;

  ForgotPasswordParams({required this.email});
}
