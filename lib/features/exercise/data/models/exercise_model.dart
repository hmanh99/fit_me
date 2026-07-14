import 'package:personal_fitness_tracker/features/exercise/domain/entities/exercise_entity.dart';

class ExerciseModel extends ExerciseEntity {
  const ExerciseModel({
    required super.exerciseId,
    required super.name,
    required super.muscleGroups,
    required super.difficulty,
    super.equipments,
    required super.instructions,
    super.url,
    super.calories,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      exerciseId: json['exercise_id'] as int,
      name: json['name'] as String,
      muscleGroups: List<String>.from(json['muscle_group'] ?? []),
      difficulty: DifficultyLevel.fromString(json['difficulty'] as String?),
      equipments: json['equipment'] != null
          ? List<String>.from(json['equipment'])
          : null,
      instructions: List<String>.from(json['instructions'] ?? []),
      url: json['url'] as String?,
      calories: json['calories'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exercise_id': exerciseId,
      'name': name,
      'muscle_group': muscleGroups,
      'difficulty': difficulty.toDbValue(),
      'equipment': equipments,
      'instructions': instructions,
      'url': url,
      'calories': calories,
    };
  }

  @override
  ExerciseEntity copyWith({
    int? exerciseId,
    String? name,
    List<String>? muscleGroups,
    DifficultyLevel? difficulty,
    List<String>? equipments,
    List<String>? instructions,
    String? url,
    int? calories,
  }) {
    // TODO: implement copyWith
    return super.copyWith(
      exerciseId: exerciseId,
      name: name,
      muscleGroups: muscleGroups,
      difficulty: difficulty,
      equipments: equipments,
      instructions: instructions,
      url: url,
      calories: calories,
    );
  }
}
