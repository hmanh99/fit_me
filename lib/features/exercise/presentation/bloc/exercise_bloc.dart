import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_fitness_tracker/features/exercise/domain/repositories/exercise_repository.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_event.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final ExerciseRepository exerciseRepository;

  ExerciseBloc({required this.exerciseRepository}) : super(ExerciseInitial()) {
    on<ExerciseFetchStarted>(_onExerciseFetchStarted);
    on<ExerciseFetchByIdStarted>(_onExerciseFetchByIdStarted);
  }

  Future<void> _onExerciseFetchStarted(
    ExerciseFetchStarted event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseLoading());
    try {
      final exercises = await exerciseRepository.getExercises();
      if (exercises.isEmpty) {
        emit(ExerciseEmpty());
      } else {
        emit(ExerciseSuccess(exercises: exercises));
      }
    } catch (e) {
      emit(ExerciseError(message: e.toString()));
    }
  }

  Future<void> _onExerciseFetchByIdStarted(
    ExerciseFetchByIdStarted event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseLoading());
    try {
      final exercise = await exerciseRepository.getExerciseById(event.exerciseId);
      emit(ExerciseDetailSuccess(exercise: exercise));
    } catch (e) {
      emit(ExerciseError(message: e.toString()));
    }
  }
}
