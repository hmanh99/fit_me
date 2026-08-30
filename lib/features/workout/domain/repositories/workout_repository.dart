import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/features/workout/domain/entities/set_session_entity.dart';
import 'package:fit_me/features/workout/domain/entities/workout_plan_entity.dart';
import 'package:fit_me/features/workout/domain/entities/workout_session_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class WorkoutRepository {
  Future<Either<Failure, List<WorkoutPlanEntity>>> getWorkoutPlans(String? userId);

  Future<Either<Failure, WorkoutPlanEntity>> getWorkoutPlanDetails(int planId);

  Future<Either<Failure, WorkoutPlanEntity>> createWorkoutPlan(WorkoutPlanEntity plan);

  Future<Either<Failure, WorkoutPlanEntity>> updateWorkoutPlan(WorkoutPlanEntity plan);

  Future<Either<Failure, void>> deleteWorkoutPlan(int planId);

  Future<Either<Failure, int>> createWorkoutSession(WorkoutSessionEntity session);

  Future<Either<Failure, void>> createSetSession(SetSessionEntity setSession);
}
