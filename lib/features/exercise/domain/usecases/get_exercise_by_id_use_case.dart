import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fit_me/features/exercise/domain/repositories/exercise_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetExerciseByIdUseCase
    implements UseCase<ExerciseEntity, ExerciseParams> {
  final ExerciseRepository repository;

  const GetExerciseByIdUseCase(this.repository);
  @override
  Future<Either<Failure, ExerciseEntity>> call(ExerciseParams params) =>
      repository.getExerciseById(id: params.id);
}

class ExerciseParams {
  final int id;

  ExerciseParams({required this.id});
}
