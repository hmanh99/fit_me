import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:personal_fitness_tracker/core/error/exceptions.dart';
import 'package:personal_fitness_tracker/features/workout/data/models/workout_plan_model.dart';

abstract class WorkoutRemoteDataSource {
  Future<List<WorkoutPlanModel>> getWorkoutPlans(String? userId);
  Future<WorkoutPlanModel> getWorkoutPlanDetails(int planId);
}

class WorkoutRemoteDataSourceImpl implements WorkoutRemoteDataSource {
  final SupabaseClient supabaseClient;

  WorkoutRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<WorkoutPlanModel>> getWorkoutPlans(String? userId) async {
    try {
      final List<Map<String, dynamic>> response;

      if (userId != null) {
        response = await supabaseClient
            .from('workout_plans')
            .select()
            .or('user_id.eq.$userId,user_id.is.null');
      } else {
        response = await supabaseClient
            .from('workout_plans')
            .select()
            .isFilter('user_id', null);
      }

      return response.map((e) => WorkoutPlanModel.fromJson(e)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<WorkoutPlanModel> getWorkoutPlanDetails(int planId) async {
    try {
      // Fetch plan and its exercises joined
      final response = await supabaseClient
          .from('workout_plans')
          .select('*, plan_exercises(*, exercises(*))')
          .eq('plan_id', planId)
          .single();
      return WorkoutPlanModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
