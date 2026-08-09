import 'package:personal_fitness_tracker/features/workout/domain/entities/set_session_entity.dart';
import 'package:personal_fitness_tracker/features/workout/domain/repositories/workout_repository.dart';

class CreateSetSessionUseCase {
  final WorkoutRepository repository;

  const CreateSetSessionUseCase(this.repository);

  Future<void> call(SetSessionEntity setSession) {
    return repository.createSetSession(setSession);
  }
}
