import 'package:personal_fitness_tracker/features/auth/domain/entities/user_entities.dart';
import 'package:personal_fitness_tracker/features/auth/domain/repositories/auth_repository.dart';

class WatchAuthStateUseCase {
  final AuthRepository repository;

  const WatchAuthStateUseCase(this.repository);

  Stream<UserEntity?> call() => repository.watchAuthState();
}
