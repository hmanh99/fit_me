import 'package:fit_me/features/workout/domain/usecases/create_workout_plan_use_case.dart';
import 'package:fit_me/features/workout/domain/usecases/delete_workout_plan_use_case.dart';
import 'package:fit_me/features/workout/domain/usecases/get_workout_plan_details_use_case.dart';
import 'package:fit_me/features/workout/domain/usecases/get_workout_plans_use_case.dart';
import 'package:fit_me/features/workout/domain/usecases/update_workout_plan_use_case.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_event.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final GetWorkoutPlansUseCase _getWorkoutPlans;
  final GetWorkoutPlanDetailsUseCase _getWorkoutPlanDetails;
  final CreateWorkoutPlanUseCase _createWorkoutPlan;
  final UpdateWorkoutPlanUseCase _updateWorkoutPlan;
  final DeleteWorkoutPlanUseCase _deleteWorkoutPlan;

  WorkoutBloc({
    required GetWorkoutPlansUseCase getWorkoutPlans,
    required GetWorkoutPlanDetailsUseCase getWorkoutPlanDetails,
    required CreateWorkoutPlanUseCase createWorkoutPlan,
    required UpdateWorkoutPlanUseCase updateWorkoutPlan,
    required DeleteWorkoutPlanUseCase deleteWorkoutPlan,
  })  : _getWorkoutPlans = getWorkoutPlans,
        _getWorkoutPlanDetails = getWorkoutPlanDetails,
        _createWorkoutPlan = createWorkoutPlan,
        _updateWorkoutPlan = updateWorkoutPlan,
        _deleteWorkoutPlan = deleteWorkoutPlan,
        super(WorkoutInitial()) {
    on<WorkoutFetchPlansStarted>(_onFetchPlansStarted);
    on<WorkoutFetchPlanDetailsStarted>(_onFetchPlanDetailsStarted);
    on<WorkoutCreatePlanStarted>(_onCreatePlanStarted);
    on<WorkoutUpdatePlanStarted>(_onUpdatePlanStarted);
    on<WorkoutDeletePlanStarted>(_onDeletePlanStarted);
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
          emit(WorkoutError(message: failure.message));
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
      result.fold(
        (failure) {
          emit(WorkoutError(message: failure.message));
        },
        (plan) => emit(WorkoutPlanDetailsLoaded(workoutPlan: plan)),
      );
    } catch (e) {
      emit(WorkoutError(message: e.toString()));
    }
  }

  Future<void> _onCreatePlanStarted(
    WorkoutCreatePlanStarted event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutPlanActionInProgress());
    try {
      final result = await _createWorkoutPlan(
        CreateWorkoutPlanParams(plan: event.plan),
      );
      result.fold(
        (failure) => emit(WorkoutError(message: failure.message)),
        (createdPlan) => emit(
          WorkoutPlanActionSuccess(
            message: 'plan_created_success',
            plan: createdPlan,
          ),
        ),
      );
    } catch (e) {
      emit(WorkoutError(message: e.toString()));
    }
  }

  Future<void> _onUpdatePlanStarted(
    WorkoutUpdatePlanStarted event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutPlanActionInProgress());
    try {
      final result = await _updateWorkoutPlan(
        UpdateWorkoutPlanParams(plan: event.plan),
      );
      result.fold(
        (failure) => emit(WorkoutError(message: failure.message)),
        (updatedPlan) => emit(
          WorkoutPlanActionSuccess(
            message: 'plan_updated_success',
            plan: updatedPlan,
          ),
        ),
      );
    } catch (e) {
      emit(WorkoutError(message: e.toString()));
    }
  }

  Future<void> _onDeletePlanStarted(
    WorkoutDeletePlanStarted event,
    Emitter<WorkoutState> emit,
  ) async {
    emit(WorkoutPlanActionInProgress());
    try {
      final result = await _deleteWorkoutPlan(
        DeleteWorkoutPlanParams(planId: event.planId),
      );
      result.fold(
        (failure) => emit(WorkoutError(message: failure.message)),
        (_) {
          emit(const WorkoutPlanActionSuccess(message: 'plan_deleted_success'));
        },
      );
    } catch (e) {
      emit(WorkoutError(message: e.toString()));
    }
  }
}
