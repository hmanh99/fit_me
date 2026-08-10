import 'package:fit_me/features/meal/domain/entities/meal_entity.dart';

abstract class MealRepository {
  Future<List<MealEntity>> getMeals();

  Future<MealEntity> getMealById(int id);
}
