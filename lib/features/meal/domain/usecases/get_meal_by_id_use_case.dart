import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/meal/domain/entities/meal_entity.dart';
import 'package:fit_me/features/meal/domain/repositories/meal_repository.dart';
import 'package:fpdart/src/either.dart';



class GetMealByIdUseCase implements UseCase<MealEntity, MealParams> {
  final MealRepository repository;

  const GetMealByIdUseCase(this.repository);

  @override
  Future<Either<Failure, MealEntity>> call(MealParams params) => repository.getMealById(id: params.id);
}

class MealParams {
  final int id;

  MealParams({required this.id});

}
