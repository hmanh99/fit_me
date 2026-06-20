import 'package:personal_fitness_tracker/features/workout/data/datasource/workout_remote_data_source.dart';
import 'package:personal_fitness_tracker/features/workout/domain/entities/workout_plan_entity.dart';
import 'package:personal_fitness_tracker/features/workout/domain/repositories/workout_repository.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutRemoteDataSource remoteDataSource;

  WorkoutRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<WorkoutPlanEntity>> getWorkoutPlans(String? userId) async {
    try {
      return await remoteDataSource.getWorkoutPlans(userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WorkoutPlanEntity> getWorkoutPlanDetails(int planId) async {
    try {
      return await remoteDataSource.getWorkoutPlanDetails(planId);
    } catch (e) {
      rethrow;
    }
  }
}
