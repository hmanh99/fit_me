import 'package:personal_fitness_tracker/features/meal/domain/entities/meal_entity.dart';
import 'package:personal_fitness_tracker/features/meal/domain/repositories/meal_repository.dart';

class GetMealsUseCase {
  final MealRepository repository;

  const GetMealsUseCase(this.repository);

  Future<List<MealEntity>> call() => repository.getMeals();
}
