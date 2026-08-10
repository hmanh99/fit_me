import 'package:equatable/equatable.dart';
import 'package:fit_me/features/exercise/domain/entities/exercise_entity.dart';

abstract class ExerciseState extends Equatable {
  const ExerciseState();

  @override
  List<Object?> get props => [];
}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

class ExerciseSuccess extends ExerciseState {
  final List<ExerciseEntity> exercises;

  const ExerciseSuccess({required this.exercises});

  @override
  List<Object?> get props => [exercises];
}

class ExerciseDetailSuccess extends ExerciseState {
  final ExerciseEntity exercise;

  const ExerciseDetailSuccess({required this.exercise});

  @override
  List<Object?> get props => [exercise];
}

class ExerciseEmpty extends ExerciseState {}

class ExerciseError extends ExerciseState {
  final String message;

  const ExerciseError({required this.message});

  @override
  List<Object?> get props => [message];
}
