import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/auth/domain/entities/user_entities.dart';
import 'package:fit_me/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class WatchAuthStateUseCase {
  final AuthRepository repository;

  const WatchAuthStateUseCase(this.repository);

  Stream<Either<Failure, UserEntity?>> call(NoParams params) {
    return repository.watchAuthState();
  }
}
