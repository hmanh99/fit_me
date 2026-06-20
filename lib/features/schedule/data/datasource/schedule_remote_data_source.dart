import 'dart:async';

import 'package:personal_fitness_tracker/core/error/exceptions.dart';
import 'package:personal_fitness_tracker/features/schedule/data/model/workout_schedule_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Abstract interface for schedule remote operations.
abstract class ScheduleRemoteDataSource {
  Future<List<WorkoutScheduleModel>> getSchedulesByMonth({
    required String userId,
    required int year,
    required int month,
  });

  Future<List<WorkoutScheduleModel>> getSchedulesByDate({
    required String userId,
    required DateTime date,
  });

  Future<void> addSchedule(WorkoutScheduleModel model);

  Future<void> updateSchedule(WorkoutScheduleModel model);

  Future<void> deleteSchedule(int scheduleId);

  Stream<List<WorkoutScheduleModel>> watchSchedules(String userId);
}

/// Supabase implementation of [ScheduleRemoteDataSource].
class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final SupabaseClient supabaseClient;

  ScheduleRemoteDataSourceImpl({required this.supabaseClient});

  static const _table = 'workout_schedules';

  @override
  Future<List<WorkoutScheduleModel>> getSchedulesByMonth({
    required String userId,
    required int year,
    required int month,
  }) async {
    try {
      // Build date range for the month
      final startDate = DateTime(year, month, 1);
      final endDate = DateTime(year, month + 1, 0); // last day of month

      final startStr = startDate.toIso8601String().split('T').first;
      final endStr = endDate.toIso8601String().split('T').first;

      final response = await supabaseClient
          .from(_table)
          .select()
          .eq('user_id', userId)
          .gte('schedule_date', startStr)
          .lte('schedule_date', endStr)
          .order('schedule_date', ascending: true);

      return (response as List<dynamic>)
          .map((e) => WorkoutScheduleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<WorkoutScheduleModel>> getSchedulesByDate({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final dateStr = date.toIso8601String().split('T').first;

      final response = await supabaseClient
          .from(_table)
          .select()
          .eq('user_id', userId)
          .eq('schedule_date', dateStr)
          .order('created_at', ascending: true);

      return (response as List<dynamic>)
          .map((e) => WorkoutScheduleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> addSchedule(WorkoutScheduleModel model) async {
    try {
      await supabaseClient.from(_table).insert(model.toInsertJson());
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateSchedule(WorkoutScheduleModel model) async {
    try {
      await supabaseClient
          .from(_table)
          .update(model.toUpdateJson())
          .eq('schedule_id', model.scheduleId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteSchedule(int scheduleId) async {
    try {
      await supabaseClient.from(_table).delete().eq('schedule_id', scheduleId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Stream<List<WorkoutScheduleModel>> watchSchedules(String userId) {
    final controller = StreamController<List<WorkoutScheduleModel>>.broadcast();

    final channel = supabaseClient.channel('schedule_realtime_$userId');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: _table,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) async {
            // On any change, re-fetch all schedules for the current context.
            // The Bloc will handle filtering by month/date.
            try {
              final response = await supabaseClient
                  .from(_table)
                  .select()
                  .eq('user_id', userId)
                  .order('schedule_date', ascending: true);

              final schedules = (response as List<dynamic>)
                  .map(
                    (e) => WorkoutScheduleModel.fromJson(
                      e as Map<String, dynamic>,
                    ),
                  )
                  .toList();
              if (!controller.isClosed) {
                controller.add(schedules);
              }
            } catch (e) {
              if (!controller.isClosed) {
                controller.addError(e);
              }
            }
          },
        )
        .subscribe();

    controller.onCancel = () {
      supabaseClient.removeChannel(channel);
      controller.close();
    };

    return controller.stream;
  }
}
