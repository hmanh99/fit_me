import 'package:fit_me/features/exercise/domain/entities/exercise_entity.dart';

class ExerciseModel extends ExerciseEntity {
  const ExerciseModel({
    required super.exerciseId,
    required super.name,
    required super.musclesGroup,
    super.equipments,
    required super.instructions,
    super.url,
    super.calories,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      exerciseId: json['exercise_id'] as int,
      name: json['name'] as String,
      musclesGroup: List<String>.from(json['muscles_group'] ?? []),
      equipments: json['equipment'] != null
          ? List<String>.from(json['equipment'])
          : null,
      instructions: List<String>.from(json['instructions'] ?? []),
      url: json['url'] as String?,
      calories: json['calories'] as int?,
    );
  }

  ExerciseEntity toEntity() {
    return ExerciseEntity(
      exerciseId: exerciseId,
      name: name,
      musclesGroup: musclesGroup,
      instructions: instructions,
      url: url,
      calories: calories,
      equipments: equipments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exercise_id': exerciseId,
      'name': name,
      'muscles_group': musclesGroup,
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
    List<String>? musclesGroup,
    List<String>? equipments,
    List<String>? instructions,
    String? url,
    int? calories,
  }) {
    // TODO: implement copyWith
    return super.copyWith(
      exerciseId: exerciseId,
      name: name,
      musclesGroup: musclesGroup,
      equipments: equipments,
      instructions: instructions,
      url: url,
      calories: calories,
    );
  }
}
