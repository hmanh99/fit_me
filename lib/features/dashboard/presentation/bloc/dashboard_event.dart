import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DashboardExercisesFetched extends DashboardEvent{
  const DashboardExercisesFetched();
}