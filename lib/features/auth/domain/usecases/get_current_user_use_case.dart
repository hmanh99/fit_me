import 'package:personal_fitness_tracker/features/auth/domain/entities/user_entities.dart';
import 'package:personal_fitness_tracker/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  const GetCurrentUserUseCase(this.repository);

  UserEntity? call() => repository.currentUser;
}
