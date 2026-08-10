import 'package:fit_me/features/workout/domain/entities/workout_session_entity.dart';
import 'package:fit_me/features/workout/domain/repositories/workout_repository.dart';

class CreateWorkoutSessionUseCase {
  final WorkoutRepository repository;

  const CreateWorkoutSessionUseCase(this.repository);

  Future<int> call(WorkoutSessionEntity session) {
    return repository.createWorkoutSession(session);
  }
}
