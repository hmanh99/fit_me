import 'package:equatable/equatable.dart';

class WorkoutSessionEntity extends Equatable {
  final int workoutSessionId;
  final String userId;
  final int planId;
  final String planName;
  final DateTime dateTracked;
  final DateTime startedAt;
  final DateTime? completedAt;

  const WorkoutSessionEntity({
    this.workoutSessionId = 0,
    required this.userId,
    required this.planId,
    required this.planName,
    required this.dateTracked,
    required this.startedAt,
    this.completedAt,
  });

  bool get isCompleted => completedAt != null;

  Duration? get duration {
    if (completedAt == null) return null;
    return completedAt!.difference(startedAt);
  }

  WorkoutSessionEntity copyWith({
    int? workoutSessionId,
    String? userId,
    int? planId,
    String? planName,
    DateTime? dateTracked,
    DateTime? startedAt,
    DateTime? completedAt,
    int? totalCaloriesBurned,
  }) {
    return WorkoutSessionEntity(
      workoutSessionId: workoutSessionId ?? this.workoutSessionId,
      userId: userId ?? this.userId,
      planId: planId ?? this.planId,
      planName: planName ?? this.planName,
      dateTracked: dateTracked ?? this.dateTracked,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
    workoutSessionId,
    userId,
    planId,
    planName,
    dateTracked,
    startedAt,
    completedAt,
  ];
}