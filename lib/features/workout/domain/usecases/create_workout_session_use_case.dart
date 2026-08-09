import 'package:personal_fitness_tracker/features/workout/domain/entities/workout_session_entity.dart';
import 'package:personal_fitness_tracker/features/workout/domain/repositories/workout_repository.dart';

class CreateWorkoutSessionUseCase {
  final WorkoutRepository repository;

  const CreateWorkoutSessionUseCase(this.repository);

  Future<int> call(WorkoutSessionEntity session) {
    return repository.createWorkoutSession(session);
  }
}
