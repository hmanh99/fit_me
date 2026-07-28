import 'package:personal_fitness_tracker/features/workout/domain/entities/set_session_entity.dart';
import 'package:personal_fitness_tracker/features/workout/domain/entities/workout_plan_entity.dart';
import 'package:personal_fitness_tracker/features/workout/domain/entities/workout_session_entity.dart';

abstract class WorkoutRepository {
  Future<List<WorkoutPlanEntity>> getWorkoutPlans(String? userId);

  Future<WorkoutPlanEntity> getWorkoutPlanDetails(int planId);

  Future<int> createWorkoutSession(WorkoutSessionEntity session);

  Future<void> updateWorkoutSession(WorkoutSessionEntity session);

  Future<List<WorkoutSessionEntity>> getWorkoutSessions(String userId);

  Future<void> createSetSession(SetSessionEntity setSession);
  Future<void> updateSetSession(SetSessionEntity setSession);
}
