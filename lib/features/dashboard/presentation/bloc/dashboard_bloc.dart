import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fit_me/core/services/exercise_services.dart';
import 'package:fit_me/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:fit_me/features/dashboard/presentation/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ExerciseServices exerciseServices;

  DashboardBloc({required this.exerciseServices}) : super(DashboardInitial()) {
    on<DashboardExercisesFetched>(_onExercisesFetched);
  }

  Future<void> _onExercisesFetched(
    DashboardExercisesFetched event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      emit(DashboardLoading());
      final exercises = await exerciseServices.getAllExercises();

      if (exercises.isEmpty) {
        emit(DashboardEmpty());
      } else {
        emit(DashboardExercisesFetchedSuccess(exercises: exercises));
      }
    }catch (e){
      emit(DashboardError(message: e.toString()));
    }
  }
}
