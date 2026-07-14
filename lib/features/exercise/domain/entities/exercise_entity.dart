import 'package:equatable/equatable.dart';

enum DifficultyLevel {
  beginner,
  intermediate,
  advanced;

  static DifficultyLevel fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'beginner':
        return DifficultyLevel.beginner;
      case 'intermediate':
        return DifficultyLevel.intermediate;
      case 'advanced':
        return DifficultyLevel.advanced;
      default:
        return DifficultyLevel.beginner;
    }
  }

  String? toDbValue() {
    return name; // beginner,intermediate,advanced
  }
}

class ExerciseEntity extends Equatable {
  final int exerciseId;
  final String name;
  final List<String> muscleGroups;
  final DifficultyLevel difficulty;
  final List<String>?  equipments;
  final List<String> instructions;
  final String? url;
  final int? calories;

  const ExerciseEntity({
    required this.exerciseId,
    required this.name,
    required this.muscleGroups,
    required this.difficulty,
    this.equipments,
    required this.instructions,
    this.url,
    this.calories,
  });

  bool get requiresEquipment => equipments != null && equipments!.isNotEmpty;

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
    return ExerciseEntity(
      exerciseId: exerciseId ?? this.exerciseId,
      name: name ?? this.name,
      muscleGroups: muscleGroups ?? this.muscleGroups,
      difficulty: difficulty ?? this.difficulty,
      equipments: equipments ?? this.equipments,
      instructions: instructions ?? this.instructions,
      url: url ?? this.url,
      calories: calories ?? this.calories,
    );
  }

  @override
  List<Object?> get props => [
    exerciseId,
    name,
    muscleGroups,
    difficulty,
    equipments,
    instructions,
    url,
    calories,
  ];

  @override
  String toString() =>
      'ExerciseEntity(id: $exerciseId, name: $name, muscleGroup: $muscleGroups, '
      'difficulty: $difficulty, calories: $calories)';
}
