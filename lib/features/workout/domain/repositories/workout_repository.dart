import 'package:personal_fitness_tracker/features/workout/domain/entities/workout_plan_entity.dart';

abstract class WorkoutRepository {
  Future<List<WorkoutPlanEntity>> getWorkoutPlans(String? userId);
  Future<WorkoutPlanEntity> getWorkoutPlanDetails(int planId);
}
