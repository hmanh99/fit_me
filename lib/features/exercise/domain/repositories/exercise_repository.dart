import 'package:personal_fitness_tracker/features/exercise/domain/entities/exercise_entity.dart';

abstract class ExerciseRepository {
  Future<List<ExerciseEntity>> getExercises();
  Future<ExerciseEntity> getExerciseById(int id);
}
