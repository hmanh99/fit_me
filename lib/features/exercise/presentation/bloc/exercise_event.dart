import 'package:equatable/equatable.dart';

abstract class ExerciseEvent extends Equatable {
  const ExerciseEvent();

  @override
  List<Object?> get props => [];
}

class ExerciseFetchStarted extends ExerciseEvent {
  const ExerciseFetchStarted();
}

class ExerciseFetchByIdStarted extends ExerciseEvent {
  final int exerciseId;

  const ExerciseFetchByIdStarted({required this.exerciseId});

  @override
  List<Object?> get props => [exerciseId];
}
