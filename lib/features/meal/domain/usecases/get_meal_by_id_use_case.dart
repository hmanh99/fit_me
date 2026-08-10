import 'package:fit_me/features/meal/domain/entities/meal_entity.dart';
import 'package:fit_me/features/meal/domain/repositories/meal_repository.dart';

class GetMealByIdUseCase {
  final MealRepository repository;

  const GetMealByIdUseCase(this.repository);

  Future<MealEntity> call(int id) => repository.getMealById(id);
}
