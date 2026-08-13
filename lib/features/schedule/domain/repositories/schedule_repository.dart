import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/features/schedule/domain/entities/workout_schedule_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class ScheduleRepository {
  Future<Either<Failure, List<WorkoutScheduleEntity>>> getSchedulesByMonth({
    required String userId,
    required int year,
    required int month,
  });

  Future<Either<Failure, List<WorkoutScheduleEntity>>> getSchedulesByDate({
    required String userId,
    required DateTime date,
  });

  Future<Either<Failure, void>> addSchedule({required WorkoutScheduleEntity schedule});

  Future<Either<Failure, void>> updateSchedule({required WorkoutScheduleEntity schedule});

  Future<Either<Failure, void>> deleteSchedule({required int scheduleId});

  Stream<Either<Failure, List<WorkoutScheduleEntity>>> watchSchedules({
    required String userId,
  });
}
