import 'package:fit_me/core/error/exceptions.dart';
import 'package:fit_me/features/meal/data/models/meal_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class MealRemoteDatasource {
  Future<List<MealModel>> getMeals();
  Future<MealModel> getMealById(int id);
}

class MealRemoteDatasourceImpl implements MealRemoteDatasource {
  final SupabaseClient supabaseClient;

  MealRemoteDatasourceImpl({required this.supabaseClient});

  @override
  Future<MealModel> getMealById(int id) async {
    try {
      final response = await supabaseClient
          .from('meal')
          .select()
          .eq('meal_id', id)
          .single();
      return MealModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<MealModel>> getMeals() async {
    try {
      final response = await supabaseClient
          .from('meal')
          .select()
          .order('meal_id', ascending: true);
      return (response as List).map((e) => MealModel.fromJson(e)).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
