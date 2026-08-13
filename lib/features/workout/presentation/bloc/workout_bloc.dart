import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/features/workout/domain/usecases/get_workout_plan_details_use_case.dart';
import 'package:fit_me/features/workout/domain/usecases/get_workout_plans_use_case.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_event.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final GetWorkoutPlansUseCase _getWorkoutPlans;
  final GetWorkoutPlanDetailsUseCase _getWorkoutPlanDetails;

  WorkoutBloc({
    required GetWorkoutPlansUseCase getWorkoutPlans,
    required GetWorkoutPlanDetailsUseCase getWorkoutPlanDetails,
  }) : _getWorkoutPlans = getWorkoutPlans,
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
      final result = await _getWorkoutPlans(
        WorkoutPlansParams(userId: event.userId),
      );

      result.fold(
        (failure) {
          Failure(failure.message);
          emit(WorkoutError(message: failure.toString()));
        },
        (plans) {
          if (plans.isEmpty) {
            emit(WorkoutEmpty());
          } else {
            emit(WorkoutPlansLoaded(workoutPlans: plans));
          }
        },
      );
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
      final result = await _getWorkoutPlanDetails(
        WorkoutPlanDetailParams(planId: event.planId),
      );
      result.fold((failure) {
        Failure(failure.message);
        emit(WorkoutError(message: failure.toString()));
      }, (plan) => emit(WorkoutPlanDetailsLoaded(workoutPlan: plan)));
    } catch (e) {
      emit(WorkoutError(message: e.toString()));
    }
  }
}
