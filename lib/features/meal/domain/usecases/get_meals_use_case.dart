import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/meal/domain/entities/meal_entity.dart';
import 'package:fit_me/features/meal/domain/repositories/meal_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetMealsUseCase implements UseCase<List<MealEntity>, NoParams>{
  final MealRepository repository;

  const GetMealsUseCase(this.repository);

  @override
  Future<Either<Failure, List<MealEntity>>> call(NoParams params) => repository.getMeals();
}
