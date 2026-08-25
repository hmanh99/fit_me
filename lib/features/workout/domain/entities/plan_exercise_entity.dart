import 'package:equatable/equatable.dart';

/// planExerciseId help define order of specific exercise inside a specific plan.
class PlanExerciseEntity extends Equatable {
  final int planExerciseId;
  final int planId;
  final int exerciseId;
  final String exerciseName;
  final int orderInWorkout;
  final int targetSets;
  final int targetRepsOrSeconds;
  final List<String> musclesGroup;

  const PlanExerciseEntity({
    required this.planExerciseId,
    required this.planId,
    required this.exerciseId,
    required this.orderInWorkout,
    required this.targetSets,
    required this.targetRepsOrSeconds,
    required this.exerciseName,
    required this.musclesGroup,
  });

  int get expectedVolume => targetSets * targetRepsOrSeconds;

  PlanExerciseEntity copyWith({
    int? planExerciseId,
    int? planId,
    int? exerciseId,
    int? orderInWorkout,
    int? targetSets,
    int? targetRepsOrSeconds,
    String? exerciseName,
    List<String>? musclesGroup,
  }) {
    return PlanExerciseEntity(
      planExerciseId: planExerciseId ?? this.planExerciseId,
      planId: planId ?? this.planId,
      exerciseId: exerciseId ?? this.exerciseId,
      orderInWorkout: orderInWorkout ?? this.orderInWorkout,
      targetSets: targetSets ?? this.targetSets,
      targetRepsOrSeconds: targetRepsOrSeconds ?? this.targetRepsOrSeconds,
      exerciseName: exerciseName ?? this.exerciseName,
      musclesGroup: musclesGroup ?? this.musclesGroup,
    );
  }

  @override
  List<Object?> get props => [
    planExerciseId,
    planId,
    exerciseId,
    orderInWorkout,
    targetSets,
    targetRepsOrSeconds,
    exerciseName,
    musclesGroup,
  ];

  @override
  String toString() =>
      'PlanExerciseEntity(planExerciseId: $planExerciseId, exerciseId: $exerciseId, '
      'order: $orderInWorkout, sets: $targetSets, repsOrSecs: $targetRepsOrSeconds, musclesGroup: $musclesGroup)';
}
