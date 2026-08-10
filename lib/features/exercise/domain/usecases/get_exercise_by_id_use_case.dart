import 'package:fit_me/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fit_me/features/exercise/domain/repositories/exercise_repository.dart';

class GetExerciseByIdUseCase {
  final ExerciseRepository repository;

  const GetExerciseByIdUseCase(this.repository);

  Future<ExerciseEntity> call(int id) => repository.getExerciseById(id);
}
