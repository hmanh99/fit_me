import 'package:personal_fitness_tracker/features/workout/domain/entities/workout_plan_entity.dart';
import 'package:personal_fitness_tracker/features/workout/data/models/plan_exercise_model.dart';

class WorkoutPlanModel extends WorkoutPlanEntity {
  const WorkoutPlanModel({
    required super.planId,
    required super.planName,
    required super.createdAt,
    super.userId,
    super.description,
    super.planExercises = const [],
  });

  factory WorkoutPlanModel.fromJson(Map<String, dynamic> json) {
    var exercises = <PlanExerciseModel>[];
    if (json['plan_exercises'] != null) {
      exercises = (json['plan_exercises'] as List)
          .map((e) => PlanExerciseModel.fromJson(e))
          .toList();
    }
    return WorkoutPlanModel(
      planId: json['plan_id'] as int,
      userId: json['user_id'] as String?,
      planName: json['plan_name'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      planExercises: exercises,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan_id': planId,
      'user_id': userId,
      'plan_name': planName,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
