import 'package:personal_fitness_tracker/features/workout/domain/entities/workout_plan_entity.dart';
import 'package:personal_fitness_tracker/features/workout/domain/repositories/workout_repository.dart';

class GetWorkoutPlansUseCase {
  final WorkoutRepository repository;

  const GetWorkoutPlansUseCase(this.repository);

  Future<List<WorkoutPlanEntity>> call(String? userId) {
    return repository.getWorkoutPlans(userId);
  }
}
