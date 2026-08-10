import 'package:fit_me/features/profile/domain/entities/activity_history_entity.dart';

class ActivityHistoryModel extends ActivityHistoryEntity {
  const ActivityHistoryModel({
    required super.workoutSessionId,
    required super.userId,
    required super.planId,
    required super.planName,
    required super.dateTracked,
    required super.startedAt,
    required super.completedAt,
  });

  factory ActivityHistoryModel.fromJson(Map<String, dynamic> json) {
    return ActivityHistoryModel(
      workoutSessionId: json['workout_session_id'] as int? ?? 0,
      userId: json['user_id'] as String? ?? '',
      planId: json['plan_id'] as int? ?? 0,
      planName: json['plan_name'] as String,
      dateTracked: json['date_tracked'] != null
          ? DateTime.parse(json['date_tracked'] as String)
          : DateTime.now(),
      startedAt: DateTime.parse(json['started_at'] as String),

      completedAt: DateTime.parse(json['completed_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workout_session_id': workoutSessionId,
      'user_id': userId,
      'plan_id': planId,
      'plan_name': planName,
      'date_tracked': dateTracked.toUtc().toIso8601String().split('T').first,
      'started_at': startedAt.toUtc().toIso8601String(),
      'completed_at': completedAt.toUtc().toIso8601String(),
    };
  }

  factory ActivityHistoryModel.fromEntity(ActivityHistoryEntity entity) {
    return ActivityHistoryModel(
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
