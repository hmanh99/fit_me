import 'package:equatable/equatable.dart';
import 'package:fit_me/features/exercise/domain/entities/muscle_group.dart';

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

class ExerciseFilterByMuscleGroup extends ExerciseEvent {
  final MuscleGroup? muscleGroup;

  const ExerciseFilterByMuscleGroup({this.muscleGroup});

  @override
  List<Object?> get props => [muscleGroup];
}
