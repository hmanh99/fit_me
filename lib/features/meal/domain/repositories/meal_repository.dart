import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/features/meal/domain/entities/meal_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class MealRepository {
  Future<Either<Failure,List<MealEntity>>> getMeals();
  Future<Either<Failure, MealEntity>> getMealById({required int id});
}
