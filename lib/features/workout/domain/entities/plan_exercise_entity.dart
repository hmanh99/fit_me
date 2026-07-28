import 'package:equatable/equatable.dart';
import 'package:personal_fitness_tracker/features/exercise/domain/entities/exercise_entity.dart';

/// planExerciseId help define order of specific exercise inside a specific plan.
class PlanExerciseEntity extends Equatable {
  final int planExerciseId;
  final int planId;
  final int exerciseId;
  final int orderInWorkout;
  final int targetSets;
  final int targetRepsOrSeconds;

  final ExerciseEntity? exercise;

  const PlanExerciseEntity({
    required this.planExerciseId,
    required this.planId,
    required this.exerciseId,
    required this.orderInWorkout,
    required this.targetSets,
    required this.targetRepsOrSeconds,
    this.exercise,
  });

  int get expectedVolume => targetSets * targetRepsOrSeconds;

  PlanExerciseEntity copyWith({
    int? planExerciseId,
    int? planId,
    int? exerciseId,
    int? orderInWorkout,
    int? targetSets,
    int? targetRepsOrSeconds,
    ExerciseEntity? exercise,
  }) {
    return PlanExerciseEntity(
      planExerciseId: planExerciseId ?? this.planExerciseId,
      planId: planId ?? this.planId,
      exerciseId: exerciseId ?? this.exerciseId,
      orderInWorkout: orderInWorkout ?? this.orderInWorkout,
      targetSets: targetSets ?? this.targetSets,
      targetRepsOrSeconds: targetRepsOrSeconds ?? this.targetRepsOrSeconds,
      exercise: exercise ?? this.exercise,
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
    exercise,
  ];

  @override
  String toString() =>
      'PlanExerciseEntity(planExerciseId: $planExerciseId, exerciseId: $exerciseId, '
      'order: $orderInWorkout, sets: $targetSets, repsOrSecs: $targetRepsOrSeconds)';
}
