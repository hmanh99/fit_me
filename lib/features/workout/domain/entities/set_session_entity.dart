import 'package:equatable/equatable.dart';

class SetSessionEntity extends Equatable {
  final String setSessionId;
  final int workoutSessionId;
  final int exerciseId;
  final int setNumber;
  final int? repsPerformed;
  final double? weight;
  final bool isCompleted;

  const SetSessionEntity({
    required this.setSessionId,
    required this.workoutSessionId,
    required this.exerciseId,
    required this.setNumber,
    this.repsPerformed,
    this.weight,
    this.isCompleted = false,
  });

  SetSessionEntity copyWith({
    String? setSessionId,
    int? workoutSessionId,
    int? exerciseId,
    int? setNumber,
    int? repsPerformed,
    double? weight,
    bool? isCompleted,
  }) {
    return SetSessionEntity(
      setSessionId: setSessionId ?? this.setSessionId,
      workoutSessionId: workoutSessionId ?? this.workoutSessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      setNumber: setNumber ?? this.setNumber,
      repsPerformed: repsPerformed ?? this.repsPerformed,
      weight: weight ?? this.weight,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
    setSessionId,
    workoutSessionId,
    exerciseId,
    setNumber,
    repsPerformed,
    weight,
    isCompleted,
  ];
}