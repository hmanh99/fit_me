import 'package:fit_me/core/error/exceptions.dart';
import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/features/schedule/data/datasource/schedule_remote_data_source.dart';
import 'package:fit_me/features/schedule/data/model/workout_schedule_model.dart';
import 'package:fit_me/features/schedule/domain/entities/workout_schedule_entity.dart';
import 'package:fit_me/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:fpdart/fpdart.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;

  ScheduleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> addSchedule({
    required WorkoutScheduleEntity schedule,
  }) async {
    try {
      await remoteDataSource.addSchedule(
        WorkoutScheduleModel.fromEntity(schedule),
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSchedule({
    required int scheduleId,
  }) async {
    try {
      await remoteDataSource.deleteSchedule(scheduleId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WorkoutScheduleEntity>>> getSchedulesByDate({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final response = await remoteDataSource.getSchedulesByDate(
        userId: userId,
        date: date,
      );
      return Right(response.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WorkoutScheduleEntity>>> getSchedulesByMonth({
    required String userId,
    required int year,
    required int month,
  }) async {
    try {
      final response = await remoteDataSource.getSchedulesByMonth(
        userId: userId,
        month: month,
        year: year,
      );
      return Right(response.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSchedule({
    required WorkoutScheduleEntity schedule,
  }) async {
    try {
      return Right(
        await remoteDataSource.updateSchedule(
          WorkoutScheduleModel.fromEntity(schedule),
        ),
      );
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<WorkoutScheduleEntity>>> watchSchedules({
    required String userId,
  }) {
    return remoteDataSource
        .watchSchedules(userId)
        .map<Either<Failure, List<WorkoutScheduleEntity>>>(
          (models) => Right(models.map((e) => e.toEntity()).toList()),
        )
        .handleError(
          (error) => Left<Failure, List<WorkoutScheduleEntity>>(
            Failure(error.toString()),
          ),
        );
  }
}
