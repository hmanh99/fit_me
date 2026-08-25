import 'package:equatable/equatable.dart';
import 'package:fit_me/features/workout/domain/entities/workout_plan_entity.dart';

abstract class WorkoutEvent extends Equatable {
  const WorkoutEvent();

  @override
  List<Object?> get props => [];
}

class WorkoutFetchPlansStarted extends WorkoutEvent {
  final String? userId;
  const WorkoutFetchPlansStarted({this.userId});

  @override
  List<Object?> get props => [userId];
}

class WorkoutFetchPlanDetailsStarted extends WorkoutEvent {
  final int planId;
  const WorkoutFetchPlanDetailsStarted({required this.planId});

  @override
  List<Object?> get props => [planId];
}

class WorkoutCreatePlanStarted extends WorkoutEvent {
  final WorkoutPlanEntity plan;
  const WorkoutCreatePlanStarted({required this.plan});

  @override
  List<Object?> get props => [plan];
}

class WorkoutUpdatePlanStarted extends WorkoutEvent {
  final WorkoutPlanEntity plan;
  const WorkoutUpdatePlanStarted({required this.plan});

  @override
  List<Object?> get props => [plan];
}

class WorkoutDeletePlanStarted extends WorkoutEvent {
  final int planId;
  final String? userId;
  const WorkoutDeletePlanStarted({required this.planId, this.userId});

  @override
  List<Object?> get props => [planId, userId];
}
