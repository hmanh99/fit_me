import 'package:equatable/equatable.dart';
import 'package:personal_fitness_tracker/features/workout/domain/entities/workout_plan_entity.dart';

abstract class WorkoutState extends Equatable {
  const WorkoutState();

  @override
  List<Object?> get props => [];
}

class WorkoutInitial extends WorkoutState {}

class WorkoutLoading extends WorkoutState {}

class WorkoutPlansLoaded extends WorkoutState {
  final List<WorkoutPlanEntity> workoutPlans;

  const WorkoutPlansLoaded({required this.workoutPlans});

  @override
  List<Object?> get props => [workoutPlans];
}

class WorkoutPlanDetailsLoaded extends WorkoutState {
  final WorkoutPlanEntity workoutPlan;

  const WorkoutPlanDetailsLoaded({required this.workoutPlan});

  @override
  List<Object?> get props => [workoutPlan];
}

class WorkoutEmpty extends WorkoutState {}

class WorkoutError extends WorkoutState {
  final String message;

  const WorkoutError({required this.message});

  @override
  List<Object?> get props => [message];
}
