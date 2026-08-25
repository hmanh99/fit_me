import 'package:fit_me/features/workout/domain/entities/plan_exercise_entity.dart';

class PlanExerciseModel extends PlanExerciseEntity {
  const PlanExerciseModel({
    required super.planExerciseId,
    required super.planId,
    required super.exerciseId,
    required super.orderInWorkout,
    required super.targetSets,
    required super.targetRepsOrSeconds,
    required super.exerciseName,
    required super.musclesGroup,
  });

  factory PlanExerciseModel.fromJson(Map<String, dynamic> json) {
    final exercisesData = json['exercises'];
    var exerciseName = json['exercise_name'] as String? ?? '';
    var musclesGroup = <String>[];

    if (exercisesData is Map<String, dynamic>) {
      exerciseName = exercisesData['name'] as String? ?? exerciseName;
      musclesGroup = List<String>.from(exercisesData['muscles_group'] ?? []);
    } else if (json['muscles_group'] != null) {
      musclesGroup = List<String>.from(json['muscles_group']);
    }

    return PlanExerciseModel(
      planExerciseId: (json['plan_exercise_id'] as num?)?.toInt() ?? 0,
      planId: (json['plan_id'] as num?)?.toInt() ?? 0,
      exerciseId: (json['exercise_id'] as num?)?.toInt() ?? 0,
      orderInWorkout: (json['order_in_workout'] as num?)?.toInt() ?? 0,
      targetSets: (json['target_sets'] as num?)?.toInt() ?? 0,
      targetRepsOrSeconds:
          (json['target_reps_or_seconds'] as num?)?.toInt() ?? 0,
      exerciseName: exerciseName,
      musclesGroup: musclesGroup,
    );
  }

  factory PlanExerciseModel.fromEntity(PlanExerciseEntity entity) {
    return PlanExerciseModel(
      planExerciseId: entity.planExerciseId,
      planId: entity.planId,
      exerciseId: entity.exerciseId,
      orderInWorkout: entity.orderInWorkout,
      targetSets: entity.targetSets,
      targetRepsOrSeconds: entity.targetRepsOrSeconds,
      exerciseName: entity.exerciseName,
      musclesGroup: entity.musclesGroup,
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
      'exercise_name': exerciseName,
      'muscles_group': musclesGroup,
    };
  }

  Map<String, dynamic> toInsertJson([int? overridePlanId]) {
    return {
      'plan_id': overridePlanId ?? planId,
      'exercise_id': exerciseId,
      'exercise_name': exerciseName,
      'order_in_workout': orderInWorkout,
      'target_sets': targetSets,
      'target_reps_or_seconds': targetRepsOrSeconds,
      'muscles_group': musclesGroup,
    };
  }
}
