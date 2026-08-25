import 'package:fit_me/features/workout/data/models/plan_exercise_model.dart';
import 'package:fit_me/features/workout/domain/entities/workout_plan_entity.dart';

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
      planId: (json['plan_id'] as num).toInt(),
      userId: json['user_id'] as String?,
      planName: json['plan_name'] as String,
      description: json['description'] as String?,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : DateTime.now(),
      planExercises: exercises,
    );
  }

  factory WorkoutPlanModel.fromEntity(WorkoutPlanEntity entity) {
    return WorkoutPlanModel(
      planId: entity.planId,
      userId: entity.userId,
      planName: entity.planName,
      description: entity.description,
      createdAt: entity.createdAt,
      planExercises: entity.planExercises
          .map((e) => PlanExerciseModel.fromEntity(e))
          .toList(),
    );
  }

  WorkoutPlanEntity toEntity() {
    return WorkoutPlanEntity(
      userId: userId,
      planId: planId,
      planName: planName,
      createdAt: createdAt,
      description: description,
      planExercises: planExercises,
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

  Map<String, dynamic> toInsertJson() {
    final map = <String, dynamic>{
      'plan_name': planName,
      'description': description,
    };
    if (userId != null) {
      map['user_id'] = userId;
    }
    return map;
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'plan_name': planName,
      'description': description,
    };
  }
}
