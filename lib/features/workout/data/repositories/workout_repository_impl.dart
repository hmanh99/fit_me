import 'package:fit_me/core/error/exceptions.dart';
import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/features/workout/data/datasource/workout_remote_data_source.dart';
import 'package:fit_me/features/workout/data/models/set_session_entity.dart';
import 'package:fit_me/features/workout/data/models/workout_plan_model.dart';
import 'package:fit_me/features/workout/data/models/workout_session_model.dart';
import 'package:fit_me/features/workout/domain/entities/set_session_entity.dart';
import 'package:fit_me/features/workout/domain/entities/workout_plan_entity.dart';
import 'package:fit_me/features/workout/domain/entities/workout_session_entity.dart';
import 'package:fit_me/features/workout/domain/repositories/workout_repository.dart';
import 'package:fpdart/fpdart.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutRemoteDataSource remoteDataSource;

  WorkoutRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<WorkoutPlanEntity>>> getWorkoutPlans(
    String? userId,
  ) async {
    try {
      final response = await remoteDataSource.getWorkoutPlans(userId);
      return Right(response.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkoutPlanEntity>> getWorkoutPlanDetails(int planId) async {
    try {
      final response = await remoteDataSource.getWorkoutPlanDetails(planId);
      return Right(response.toEntity());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkoutPlanEntity>> createWorkoutPlan(
    WorkoutPlanEntity plan,
  ) async {
    try {
      final model = WorkoutPlanModel.fromEntity(plan);
      final response = await remoteDataSource.createWorkoutPlan(model);
      return Right(response.toEntity());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkoutPlanEntity>> updateWorkoutPlan(
    WorkoutPlanEntity plan,
  ) async {
    try {
      final model = WorkoutPlanModel.fromEntity(plan);
      final response = await remoteDataSource.updateWorkoutPlan(model);
      return Right(response.toEntity());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteWorkoutPlan(int planId) async {
    try {
      await remoteDataSource.deleteWorkoutPlan(planId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createSetSession(
    SetSessionEntity setSession,
  ) async {
    try {
      return Right(
        await remoteDataSource.createSetSession(
          SetSessionModel.fromEntity(setSession),
        ),
      );
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> createWorkoutSession(
    WorkoutSessionEntity session,
  ) async {
    try {
      return Right(
        await remoteDataSource.createWorkoutSession(
          WorkoutSessionModel.fromEntity(session),
        ),
      );
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WorkoutSessionEntity>>> getWorkoutSessions(
    String userId,
  ) async {
    try {
      final response = await remoteDataSource.getWorkoutSessions(userId);
      return Right(response.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSetSession(
    SetSessionEntity setSession,
  ) async {
    try {
      return Right(
        await remoteDataSource.updateSetSession(
          SetSessionModel.fromEntity(setSession),
        ),
      );
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateWorkoutSession(
    WorkoutSessionEntity session,
  ) async {
    try {
      return Right(
        await remoteDataSource.updateWorkoutSession(
          WorkoutSessionModel.fromEntity(session),
        ),
      );
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
