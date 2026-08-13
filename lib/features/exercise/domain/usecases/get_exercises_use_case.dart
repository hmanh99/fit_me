import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fit_me/features/exercise/domain/repositories/exercise_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetExercisesUseCase implements UseCase<List<ExerciseEntity>, NoParams> {
  final ExerciseRepository repository;

  const GetExercisesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ExerciseEntity>>> call(NoParams params) =>
      repository.getExercises();
}
