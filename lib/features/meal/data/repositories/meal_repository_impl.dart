import 'package:fit_me/core/error/exceptions.dart';
import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/features/meal/data/datasources/meal_remote_datasource.dart';
import 'package:fit_me/features/meal/domain/entities/meal_entity.dart';
import 'package:fit_me/features/meal/domain/repositories/meal_repository.dart';
import 'package:fpdart/fpdart.dart';

class MealRepositoryImpl implements MealRepository {
  final MealRemoteDatasource remoteDatasource;

  MealRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, MealEntity>> getMealById({required int id}) async {
    try {
      final response = await remoteDatasource.getMealById(id);
      return Right(response.toEntity());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MealEntity>>> getMeals() async {
    try {
      final response = await remoteDatasource.getMeals();
      return Right(response.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
