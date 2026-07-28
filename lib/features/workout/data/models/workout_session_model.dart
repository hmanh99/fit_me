import 'package:personal_fitness_tracker/features/workout/domain/entities/workout_session_entity.dart';

class WorkoutSessionModel extends WorkoutSessionEntity {
  const WorkoutSessionModel({
    super.workoutSessionId,
    required super.userId,
    required super.planId,
    required super.planName,
    required super.dateTracked,
    required super.startedAt,
    super.completedAt,
  });

  factory WorkoutSessionModel.fromJson(Map<String, dynamic> json) {
    return WorkoutSessionModel(
      workoutSessionId: json['workout_session_id'] as int,
      userId: json['user_id'] as String,
      planId: json['plan_id'] as int,
      planName: json['plan_name'] as String,
      dateTracked: DateTime.parse(json['date_tracked'] as String),
      startedAt: DateTime.parse(json['started_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workout_session_id': workoutSessionId,
      'user_id': userId,
      'plan_id': planId,
      'plan_name': planName,
      'date_tracked': dateTracked.toIso8601String().split('T').first,
      'started_at': startedAt.toIso8601String().split('T').first,
      'completed_at': completedAt?.toIso8601String().split('T').first,
    };
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'user_id': userId,
      'plan_id': planId,
      'plan_name': planName,
      'date_tracked': dateTracked.toIso8601String().split('T').first,
      'started_at': startedAt.toIso8601String().split('T').first,
      'completed_at': completedAt?.toIso8601String().split('T').first,
    };
  }
  Map<String, dynamic> toUpdateJson() {
    return {
      'user_id': userId,
      'plan_id': planId,
      'plan_name': planName,
      'date_tracked': dateTracked.toIso8601String().split('T').first,
      'started_at': startedAt.toIso8601String().split('T').first,
      'completed_at': completedAt?.toIso8601String().split('T').first,
    };
  }

  factory WorkoutSessionModel.fromEntity(WorkoutSessionEntity entity) {
    return WorkoutSessionModel(
      workoutSessionId: entity.workoutSessionId,
      userId: entity.userId,
      planId: entity.planId,
      planName: entity.planName,
      dateTracked: entity.dateTracked,
      startedAt: entity.startedAt,
      completedAt: entity.completedAt,
    );
  }
}