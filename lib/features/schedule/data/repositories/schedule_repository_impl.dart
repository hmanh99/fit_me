import 'package:personal_fitness_tracker/features/schedule/data/datasource/schedule_remote_data_source.dart';
import 'package:personal_fitness_tracker/features/schedule/data/model/workout_schedule_model.dart';
import 'package:personal_fitness_tracker/features/schedule/domain/entities/workout_schedule_entity.dart';
import 'package:personal_fitness_tracker/features/schedule/domain/repositories/schedule_repository.dart';

/// Concrete implementation of [ScheduleRepository].
/// Delegates all data operations to [ScheduleRemoteDataSource].
class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;

  ScheduleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<WorkoutScheduleEntity>> getSchedulesByMonth({
    required String userId,
    required int year,
    required int month,
  }) async {
    try {
      return await remoteDataSource.getSchedulesByMonth(
        userId: userId,
        year: year,
        month: month,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<WorkoutScheduleEntity>> getSchedulesByDate({
    required String userId,
    required DateTime date,
  }) async {
    try {
      return await remoteDataSource.getSchedulesByDate(
        userId: userId,
        date: date,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addSchedule(WorkoutScheduleEntity schedule) async {
    try {
      final model = WorkoutScheduleModel.fromEntity(schedule);
      await remoteDataSource.addSchedule(model);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateSchedule(WorkoutScheduleEntity schedule) async {
    try {
      final model = WorkoutScheduleModel.fromEntity(schedule);
      await remoteDataSource.updateSchedule(model);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteSchedule(int scheduleId) async {
    try {
      await remoteDataSource.deleteSchedule(scheduleId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<WorkoutScheduleEntity>> watchSchedules(String userId) {
    return remoteDataSource.watchSchedules(userId);
  }
}
