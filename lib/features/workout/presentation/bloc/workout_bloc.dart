import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_fitness_tracker/features/workout/domain/repositories/workout_repository.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_event.dart';
import 'package:personal_fitness_tracker/features/workout/presentation/bloc/workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final WorkoutRepository workoutRepository;

  WorkoutBloc({required this.workoutRepository}) : super(WorkoutInitial()) {
    on<WorkoutFetchPlansStarted>(_onFetchPlansStarted);
    on<WorkoutFetchPlanDetailsStarted>(_onFetchPlanDetailsStarted);
  }

  Future<void> _onFetchPlansStarted(
    WorkoutFetchPlansStarted event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutLoading());
    try {
      final plans = await workoutRepository.getWorkoutPlans(event.userId);
      if (plans.isEmpty) {
        emit(WorkoutEmpty());
      } else {
        emit(WorkoutPlansLoaded(workoutPlans: plans));
      }
    } catch (e) {
      emit(WorkoutError(message: e.toString()));
    }
  }

  Future<void> _onFetchPlanDetailsStarted(
    WorkoutFetchPlanDetailsStarted event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutLoading());
    try {
      final plan = await workoutRepository.getWorkoutPlanDetails(event.planId);
      emit(WorkoutPlanDetailsLoaded(workoutPlan: plan));
    } catch (e) {
      emit(WorkoutError(message: e.toString()));
    }
  }
}
