import 'package:fit_me/features/exercise/data/datasource/exercise_remote_data_source.dart';
import 'package:fit_me/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fit_me/features/exercise/domain/repositories/exercise_repository.dart';

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
