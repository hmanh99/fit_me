import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_fitness_tracker/features/exercise/domain/usecases/get_exercise_by_id_use_case.dart';
import 'package:personal_fitness_tracker/features/exercise/domain/usecases/get_exercises_use_case.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_event.dart';
import 'package:personal_fitness_tracker/features/exercise/presentation/bloc/exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final GetExercisesUseCase _getExercises;
  final GetExerciseByIdUseCase _getExerciseById;

  ExerciseBloc({
    required GetExercisesUseCase getExercises,
    required GetExerciseByIdUseCase getExerciseById,
  })  : _getExercises = getExercises,
        _getExerciseById = getExerciseById,
        super(ExerciseInitial()) {
    on<ExerciseFetchStarted>(_onExerciseFetchStarted);
    on<ExerciseFetchByIdStarted>(_onExerciseFetchByIdStarted);
  }

  Future<void> _onExerciseFetchStarted(
    ExerciseFetchStarted event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(ExerciseLoading());
    try {
      final exercises = await _getExercises();
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
      final exercise = await _getExerciseById(event.exerciseId);
      emit(ExerciseDetailSuccess(exercise: exercise));
    } catch (e) {
      emit(ExerciseError(message: e.toString()));
    }
  }
}
