import 'package:fit_me/features/workout/data/datasource/workout_remote_data_source.dart';
import 'package:fit_me/features/workout/data/models/set_session_entity.dart';
import 'package:fit_me/features/workout/data/models/workout_session_model.dart';
import 'package:fit_me/features/workout/domain/entities/set_session_entity.dart';
import 'package:fit_me/features/workout/domain/entities/workout_plan_entity.dart';
import 'package:fit_me/features/workout/domain/entities/workout_session_entity.dart';
import 'package:fit_me/features/workout/domain/repositories/workout_repository.dart';

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

  @override
  Future<int> createWorkoutSession(WorkoutSessionEntity session) async {
    try {
      return await remoteDataSource.createWorkoutSession(
        WorkoutSessionModel.fromEntity(session),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateWorkoutSession(WorkoutSessionEntity session) async {
    try {
      return await remoteDataSource.updateWorkoutSession(
        WorkoutSessionModel.fromEntity(session),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<WorkoutSessionEntity>> getWorkoutSessions(String userId) async {
    try {
      return await remoteDataSource.getWorkoutSessions(userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createSetSession(SetSessionEntity setSession) async {
    try {
      await remoteDataSource.createSetSession(
        SetSessionModel.fromEntity(setSession),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateSetSession(SetSessionEntity setSession) async {
    try {
      await remoteDataSource.updateSetSession(
        SetSessionModel.fromEntity(setSession),
      );
    } catch (e) {
      rethrow;
    }
  }
}
