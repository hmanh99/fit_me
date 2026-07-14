import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardEmpty extends DashboardState {}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}

class DashboardExercisesFetchedSuccess extends DashboardState {
  final List<Map<String, dynamic>> exercises;

  const DashboardExercisesFetchedSuccess({required this.exercises});

  @override
  // TODO: implement props
  List<Object?> get props => [exercises];
}
