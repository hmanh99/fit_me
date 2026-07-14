import 'package:personal_fitness_tracker/features/meal/data/datasources/meal_remote_datasource.dart';
import 'package:personal_fitness_tracker/features/meal/domain/entities/meal_entity.dart';
import 'package:personal_fitness_tracker/features/meal/domain/repositories/meal_repository.dart';

class MealRepositoryImpl implements MealRepository {
  final MealRemoteDatasource remoteDatasource;

  MealRepositoryImpl({required this.remoteDatasource});

  @override
  Future<MealEntity> getMealById(int id) async {
    try {
      return await remoteDatasource.getMealById(id);
    } catch (e){
      rethrow;
    }
  }

  @override
  Future<List<MealEntity>> getMeals() async {
    try {
      return await remoteDatasource.getMeals();
    } catch (e){
      rethrow;
    }
  }
}
