import 'package:fit_me/features/exercise/domain/entities/exercise_entity.dart';
import 'package:fit_me/features/exercise/domain/repositories/exercise_repository.dart';

class GetExercisesUseCase {
  final ExerciseRepository repository;

  const GetExercisesUseCase(this.repository);

  Future<List<ExerciseEntity>> call() => repository.getExercises();
}
