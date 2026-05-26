import 'package:equatable/equatable.dart';

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
