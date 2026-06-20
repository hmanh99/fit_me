import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:personal_fitness_tracker/core/error/exceptions.dart';
import 'package:personal_fitness_tracker/features/exercise/data/models/exercise_model.dart';

abstract class ExerciseRemoteDataSource {
  Future<List<ExerciseModel>> getExercises();
  Future<ExerciseModel> getExerciseById(int id);
}

class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final SupabaseClient supabaseClient;

  ExerciseRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<ExerciseModel>> getExercises() async {
    try {
      final response = await supabaseClient.from('exercises').select();
      return (response as List).map((e) => ExerciseModel.fromJson(e)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ExerciseModel> getExerciseById(int id) async {
    try {
      final response = await supabaseClient
          .from('exercises')
          .select()
          .eq('exercise_id', id)
          .single();
      return ExerciseModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
