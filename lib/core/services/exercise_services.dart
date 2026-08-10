import 'package:fit_me/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExerciseServices {
  ExerciseServices();

  SupabaseClient get _client => Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAllExercises() async {
    try {
      final response = await _client
          .from('exercises')
          .select();

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> getExerciseById(String id) async {
    try {
      final response = await _client
          .from('exercises')
          .select()
          .eq('exercise_id', id)
          .single();

      return Map<String, dynamic>.from(response);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}