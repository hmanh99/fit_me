import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';

class LogoutProfileUseCase implements UseCase<void, NoParams> {
  final ProfileRepository repository;

  const LogoutProfileUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return repository.logoutProfile();
  }
}
