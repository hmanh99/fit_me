import 'package:personal_fitness_tracker/features/meal/domain/entities/meal_entity.dart';

abstract class MealRepository {
  Future<List<MealEntity>> getMeals();

  Future<MealEntity> getMealById(int id);
}
