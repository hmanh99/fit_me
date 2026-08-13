import 'package:fit_me/core/error/exceptions.dart';
import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/features/exercise/data/datasource/exercise_remote_data_source.dart';
import 'package:fit_me/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fit_me/features/exercise/domain/repositories/exercise_repository.dart';
import 'package:fpdart/fpdart.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  final ExerciseRemoteDataSource remoteDataSource;

  ExerciseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ExerciseEntity>> getExerciseById({
    required int id,
  }) async {
    try {
      final response = await remoteDataSource.getExerciseById(id);
      return Right(response.toEntity());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ExerciseEntity>>> getExercises() async {
    try {
      final response = await remoteDataSource.getExercises();
      return Right(response.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
