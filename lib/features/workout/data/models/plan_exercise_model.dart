import 'package:fit_me/features/exercise/data/models/exercise_model.dart';
import 'package:fit_me/features/workout/domain/entities/plan_exercise_entity.dart';

class PlanExerciseModel extends PlanExerciseEntity {
  const PlanExerciseModel({
    required super.planExerciseId,
    required super.planId,
    required super.exerciseId,
    required super.orderInWorkout,
    required super.targetSets,
    required super.targetRepsOrSeconds,
    super.exercise,
  });

  factory PlanExerciseModel.fromJson(Map<String, dynamic> json) {
    return PlanExerciseModel(
      planExerciseId: json['plan_exercise_id'] as int,
      planId: json['plan_id'] as int,
      exerciseId: json['exercise_id'] as int,
      orderInWorkout: json['order_in_workout'] as int,
      targetSets: json['target_sets'] as int,
      targetRepsOrSeconds: json['target_reps_or_seconds'] as int,
      exercise: json['exercises'] != null
          ? ExerciseModel.fromJson(json['exercises'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan_exercise_id': planExerciseId,
      'plan_id': planId,
      'exercise_id': exerciseId,
      'order_in_workout': orderInWorkout,
      'target_sets': targetSets,
      'target_reps_or_seconds': targetRepsOrSeconds,
    };
  }
}
