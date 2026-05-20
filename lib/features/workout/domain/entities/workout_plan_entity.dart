import 'package:equatable/equatable.dart';


class WorkoutPlanEntity extends Equatable {
  final int planId;
  final String? userId;         // NULL → default/system plan
  final String planName;
  final String? description;    // nullable
  final DateTime createdAt;

  /// Ordered list of exercise slots in this plan.
  /// Sorted by [PlanExerciseEntity.orderInWorkout] ascending.
  final List<PlanExerciseEntity> planExercises;

  const WorkoutPlanEntity({
    required this.planId,
    required this.planName,
    required this.createdAt,
    this.userId,
    this.description,
    this.planExercises = const [],
  });

  /// True when this is a system/default plan (not owned by any user).
  bool get isDefaultPlan => userId == null;

  /// Total number of exercise slots in this plan.
  int get exerciseCount => planExercises.length;

  WorkoutPlanEntity copyWith({
    int? planId,
    String? userId,
    String? planName,
    String? description,
    DateTime? createdAt,
    List<PlanExerciseEntity>? planExercises,
  }) {
    return WorkoutPlanEntity(
      planId: planId ?? this.planId,
      userId: userId ?? this.userId,
      planName: planName ?? this.planName,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      planExercises: planExercises ?? this.planExercises,
    );
  }

  @override
  List<Object?> get props => [
    planId,
    userId,
    planName,
    description,
    createdAt,
    planExercises,
  ];

  @override
  String toString() =>
      'WorkoutPlanEntity(planId: $planId, planName: $planName, '
          'userId: $userId, exercises: ${planExercises.length})';
}