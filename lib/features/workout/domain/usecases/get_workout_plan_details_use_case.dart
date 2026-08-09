import 'package:personal_fitness_tracker/features/workout/domain/entities/workout_plan_entity.dart';
import 'package:personal_fitness_tracker/features/workout/domain/repositories/workout_repository.dart';

class GetWorkoutPlanDetailsUseCase {
  final WorkoutRepository repository;

  const GetWorkoutPlanDetailsUseCase(this.repository);

  Future<WorkoutPlanEntity> call(int planId) {
    return repository.getWorkoutPlanDetails(planId);
  }
}
