import 'package:equatable/equatable.dart';
import 'package:fit_me/features/workout/domain/entities/plan_exercise_entity.dart';

class WorkoutPlanEntity extends Equatable {
  final int planId;
  final String? userId; // NULL → default/system plan
  final String planName;
  final String? description;
  final DateTime createdAt;
  final List<PlanExerciseEntity> planExercises;

  const WorkoutPlanEntity({
    required this.planId,
    required this.planName,
    required this.createdAt,
    this.userId,
    this.description,
    this.planExercises = const [],
  });

  /// True when this is a default plan
  bool get isDefaultPlan => userId == null;

  /// Total number of exercise in plan.
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
