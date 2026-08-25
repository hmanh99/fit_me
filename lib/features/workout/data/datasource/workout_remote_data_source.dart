import 'package:fit_me/core/error/exceptions.dart';
import 'package:fit_me/features/workout/data/models/plan_exercise_model.dart';
import 'package:fit_me/features/workout/data/models/set_session_entity.dart';
import 'package:fit_me/features/workout/data/models/workout_plan_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/workout_session_model.dart';

abstract class WorkoutRemoteDataSource {
  Future<List<WorkoutPlanModel>> getWorkoutPlans(String? userId);

  Future<WorkoutPlanModel> getWorkoutPlanDetails(int planId);

  Future<WorkoutPlanModel> createWorkoutPlan(WorkoutPlanModel plan);

  Future<WorkoutPlanModel> updateWorkoutPlan(WorkoutPlanModel plan);

  Future<void> deleteWorkoutPlan(int planId);

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
            .select('*, plan_exercises(*, exercises(*))')
            .or('user_id.eq.$userId,user_id.is.null')
            .order('created_at', ascending: false);
      } else {
        response = await supabaseClient
            .from('workout_plans')
            .select('*, plan_exercises(*, exercises(*))')
            .isFilter('user_id', null)
            .order('created_at', ascending: false);
      }

      return response.map((e) => WorkoutPlanModel.fromJson(e)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<WorkoutPlanModel> getWorkoutPlanDetails(int planId) async {
    try {
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
  Future<WorkoutPlanModel> createWorkoutPlan(WorkoutPlanModel plan) async {
    try {
      final insertedPlan = await supabaseClient
          .from('workout_plans')
          .insert(plan.toInsertJson())
          .select()
          .single();

      final int newPlanId = (insertedPlan['plan_id'] as num).toInt();

      if (plan.planExercises.isNotEmpty) {
        final exerciseRows = plan.planExercises.asMap().entries.map((entry) {
          final idx = entry.key;
          final ex = entry.value;
          final exModel = PlanExerciseModel.fromEntity(ex);
          return {
            'plan_id': newPlanId,
            'exercise_id': exModel.exerciseId,
            'order_in_workout': idx + 1,
            'target_sets': exModel.targetSets,
            'target_reps_or_seconds': exModel.targetRepsOrSeconds,
          };
        }).toList();

        await supabaseClient.from('plan_exercises').insert(exerciseRows);
      }

      return await getWorkoutPlanDetails(newPlanId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<WorkoutPlanModel> updateWorkoutPlan(WorkoutPlanModel plan) async {
    try {
      await supabaseClient
          .from('workout_plans')
          .update(plan.toUpdateJson())
          .eq('plan_id', plan.planId);

      // Replace plan exercises
      await supabaseClient
          .from('plan_exercises')
          .delete()
          .eq('plan_id', plan.planId);

      if (plan.planExercises.isNotEmpty) {
        final exerciseRows = plan.planExercises.asMap().entries.map((entry) {
          final idx = entry.key;
          final ex = entry.value;
          final exModel = PlanExerciseModel.fromEntity(ex);
          return {
            'plan_id': plan.planId,
            'exercise_id': exModel.exerciseId,
            'order_in_workout': idx + 1,
            'target_sets': exModel.targetSets,
            'target_reps_or_seconds': exModel.targetRepsOrSeconds,
          };
        }).toList();

        await supabaseClient.from('plan_exercises').insert(exerciseRows);
      }

      return await getWorkoutPlanDetails(plan.planId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteWorkoutPlan(int planId) async {
    try {
      await supabaseClient
          .from('plan_exercises')
          .delete()
          .eq('plan_id', planId);

      await supabaseClient
          .from('workout_plans')
          .delete()
          .eq('plan_id', planId);
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
          .insert(setSession.toInsertJson());
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
