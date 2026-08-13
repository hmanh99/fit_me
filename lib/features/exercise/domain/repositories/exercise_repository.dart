import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class ExerciseRepository {
  Future<Either<Failure, List<ExerciseEntity>>> getExercises();

  Future<Either<Failure, ExerciseEntity>> getExerciseById({required int id});
}
