import 'package:personal_fitness_tracker/features/exercise/data/datasources/exercise_remote_data_source.dart';
import 'package:personal_fitness_tracker/features/exercise/domain/entities/exercise_entity.dart';
import 'package:personal_fitness_tracker/features/exercise/domain/repositories/exercise_repository.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseRemoteDataSource remoteDataSource;

  ExerciseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ExerciseEntity>> getExercises() async {
    try {
      return await remoteDataSource.getExercises();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ExerciseEntity> getExerciseById(int id) async {
    try {
      return await remoteDataSource.getExerciseById(id);
    } catch (e) {
      rethrow;
    }
  }
}
