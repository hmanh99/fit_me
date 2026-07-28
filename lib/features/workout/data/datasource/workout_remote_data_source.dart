import 'package:personal_fitness_tracker/core/error/exceptions.dart';
import 'package:personal_fitness_tracker/features/workout/data/models/set_session_entity.dart';
import 'package:personal_fitness_tracker/features/workout/data/models/workout_plan_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/workout_session_model.dart';

abstract class WorkoutRemoteDataSource {
  Future<List<WorkoutPlanModel>> getWorkoutPlans(String? userId);

  Future<WorkoutPlanModel> getWorkoutPlanDetails(int planId);

  Future<int> createWorkoutSession(WorkoutSessionModel session);

  Future<void> updateWorkoutSession(WorkoutSessionModel session);

  Future<List<WorkoutSessionModel>> getWorkoutSessions(String userId);


  Future<void> createSetSession(SetSessionModel session);

  Future<void> updateSetSession(SetSessionModel session);
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

  @override
  Future<int> createWorkoutSession(WorkoutSessionModel session) async {
    try {
      final response = await supabaseClient
          .from('workout_sessions')
          .insert(session.toInsertJson())
          .select('workout_session_id')
          .single();
      return response['workout_session_id'] as int;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateWorkoutSession(WorkoutSessionModel session) async {
    try {
      await supabaseClient
          .from('workout_sessions')
          .update(session.toUpdateJson())
          .eq('workout_session_id', session.workoutSessionId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<WorkoutSessionModel>> getWorkoutSessions(String userId) async {
    try {
      final response = await supabaseClient
          .from('workout_sessions')
          .select()
          .eq('user_id', userId);
      return (response as List<dynamic>)
          .map((e) => WorkoutSessionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> createSetSession(SetSessionModel setSession) async {
    try {
      await supabaseClient
          .from('set_sessions')
          .insert(setSession.toInsertJson()
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateSetSession(SetSessionModel setSession) async {
    try {
      await supabaseClient
          .from('set_sessions')
          .update(setSession.toUpdateJson())
          .eq('set_session_id', setSession.setSessionId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
