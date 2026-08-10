import 'package:fit_me/features/meal/domain/entities/meal_entity.dart';
import 'package:fit_me/features/meal/domain/repositories/meal_repository.dart';

class GetMealsUseCase {
  final MealRepository repository;

  const GetMealsUseCase(this.repository);

  Future<List<MealEntity>> call() => repository.getMeals();
}
