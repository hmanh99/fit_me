import 'package:fit_me/features/profile/data/models/activity_history_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';

abstract class ActivityHistoryRemoteDatasource {
  Future<List<ActivityHistoryModel>> getActitivyHistories({
    required String userId,
  });

  Future<Map<DateTime, int>> getActivityHeatmapCounts({
    required String userId,
    int days = 365,
  });

  Future<List<DateTime>> getActivityTimestamps({
    required String userId,
    int days = 365,
  });
}

class ActivityHistoryRemoteDataSourceImpl implements ActivityHistoryRemoteDatasource {
  final SupabaseClient supabaseClient;

  ActivityHistoryRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<ActivityHistoryModel>> getActitivyHistories({
    required String userId,
  }) async {
    try {
      final response = await supabaseClient
          .from('workout_sessions')
          .select()
          .eq('user_id', userId)
          .order('started_at', ascending: false);
      return (response as List<dynamic>)
          .map((history) => ActivityHistoryModel.fromJson(history as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<DateTime>> getActivityTimestamps({
    required String userId,
    int days = 365,
  }) async {
    try {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day).subtract(Duration(days: days - 1));

      final response = await supabaseClient
          .from('workout_sessions')
          .select('started_at')
          .eq('user_id', userId)
          .gte('started_at', startDate.toUtc().toIso8601String())
          .order('started_at', ascending: true);

      final List<DateTime> timestamps = [];
      for (final item in response as List<dynamic>) {
        final startedAtStr = (item as Map<String, dynamic>)['started_at'] as String?;
        if (startedAtStr != null) {
          timestamps.add(DateTime.parse(startedAtStr));
        }
      }
      return timestamps;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<DateTime, int>> getActivityHeatmapCounts({
    required String userId,
    int days = 365,
  }) async {
    try {
      final timestamps = await getActivityTimestamps(userId: userId, days: days);
      final Map<DateTime, int> counts = {};

      for (final timestamp in timestamps) {
        final localDate = timestamp.toLocal();
        final dayKey = DateTime(localDate.year, localDate.month, localDate.day);
        counts[dayKey] = (counts[dayKey] ?? 0) + 1;
      }

      return counts;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}