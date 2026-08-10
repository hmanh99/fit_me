import 'package:fit_me/features/schedule/domain/entities/workout_schedule_entity.dart';

/// Abstract contract for schedule data operations.
/// Implemented by [ScheduleRepositoryImpl] in the data layer.
abstract class ScheduleRepository {
  /// Fetches all schedules for a user within a given month.
  Future<List<WorkoutScheduleEntity>> getSchedulesByMonth({
    required String userId,
    required int year,
    required int month,
  });

  /// Fetches schedules for a specific date.
  Future<List<WorkoutScheduleEntity>> getSchedulesByDate({
    required String userId,
    required DateTime date,
  });

  /// Creates a new workout schedule entry.
  Future<void> addSchedule(WorkoutScheduleEntity schedule);

  /// Updates an existing workout schedule.
  Future<void> updateSchedule(WorkoutScheduleEntity schedule);

  /// Deletes a schedule by its ID.
  Future<void> deleteSchedule(int scheduleId);

  /// Returns a stream that emits whenever workout_schedules changes
  /// for the given user (via Supabase Realtime).
  Stream<List<WorkoutScheduleEntity>> watchSchedules(String userId);
}
