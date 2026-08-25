import 'package:equatable/equatable.dart';

class ExerciseEntity extends Equatable {
  final int exerciseId;
  final String name;
  final List<String> musclesGroup;
  final List<String>? equipments;
  final List<String> instructions;
  final String? url;
  final int? calories;

  const ExerciseEntity({
    required this.exerciseId,
    required this.name,
    required this.musclesGroup,
    this.equipments,
    required this.instructions,
    this.url,
    this.calories,
  });

  bool get requiresEquipment => equipments != null && equipments!.isNotEmpty;

  ExerciseEntity copyWith({
    int? exerciseId,
    String? name,
    List<String>? musclesGroup,
    List<String>? equipments,
    List<String>? instructions,
    String? url,
    int? calories,
  }) {
    return ExerciseEntity(
      exerciseId: exerciseId ?? this.exerciseId,
      name: name ?? this.name,
      musclesGroup: musclesGroup ?? this.musclesGroup,
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
    musclesGroup,
    equipments,
    instructions,
    url,
    calories,
  ];

  @override
  String toString() =>
      'ExerciseEntity(id: $exerciseId, name: $name, muscleGroup: $musclesGroup, calories: $calories)';
}
