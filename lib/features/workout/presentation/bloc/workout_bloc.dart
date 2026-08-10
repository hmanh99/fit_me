import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fit_me/features/workout/domain/usecases/get_workout_plan_details_use_case.dart';
import 'package:fit_me/features/workout/domain/usecases/get_workout_plans_use_case.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_event.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_state.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final GetWorkoutPlansUseCase _getWorkoutPlans;
  final GetWorkoutPlanDetailsUseCase _getWorkoutPlanDetails;

  WorkoutBloc({
    required GetWorkoutPlansUseCase getWorkoutPlans,
    required GetWorkoutPlanDetailsUseCase getWorkoutPlanDetails,
  })  : _getWorkoutPlans = getWorkoutPlans,
        _getWorkoutPlanDetails = getWorkoutPlanDetails,
        super(WorkoutInitial()) {
    on<WorkoutFetchPlansStarted>(_onFetchPlansStarted);
    on<WorkoutFetchPlanDetailsStarted>(_onFetchPlanDetailsStarted);
  }

  Future<void> _onFetchPlansStarted(
    WorkoutFetchPlansStarted event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutLoading());
    try {
      final plans = await _getWorkoutPlans(event.userId);
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
      final plan = await _getWorkoutPlanDetails(event.planId);
      emit(WorkoutPlanDetailsLoaded(workoutPlan: plan));
    } catch (e) {
      emit(WorkoutError(message: e.toString()));
    }
  }
}
