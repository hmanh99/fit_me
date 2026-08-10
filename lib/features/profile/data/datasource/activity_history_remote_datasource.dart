import 'package:fit_me/features/profile/data/models/activity_history_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';

abstract class ActivityHistoryRemoteDatasource {
  Future<List<ActivityHistoryModel>> getActitivyHistories({
    required String userId,
  });
}

class ActivityHistoryRemoteDataSourceImpl implements ActivityHistoryRemoteDatasource{
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
}