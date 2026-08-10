import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fit_me/core/services/auth_services.dart';
import 'package:fit_me/features/workout/domain/entities/set_session_entity.dart';
import 'package:fit_me/features/workout/domain/entities/workout_plan_entity.dart';
import 'package:fit_me/features/workout/domain/entities/workout_session_entity.dart';
import 'package:fit_me/features/workout/domain/usecases/create_set_session_use_case.dart';
import 'package:fit_me/features/workout/domain/usecases/create_workout_session_use_case.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_session_event.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_session_state.dart';

class WorkoutSessionBloc
    extends Bloc<WorkoutSessionEvent, WorkoutSessionState> {
  final CreateWorkoutSessionUseCase _createWorkoutSession;
  final CreateSetSessionUseCase _createSetSession;
  Timer? _elapsedTimer;
  Timer? _restTimer;
  WorkoutStatus _statusBeforePause = WorkoutStatus.running;

  static WorkoutPlanEntity _emptyPlan() {
    return WorkoutPlanEntity(
      planId: 0,
      planName: '',
      createdAt: DateTime.now(),
      planExercises: const [],
    );
  }

  WorkoutSessionBloc({
    required CreateWorkoutSessionUseCase createWorkoutSession,
    required CreateSetSessionUseCase createSetSession,
  })  : _createWorkoutSession = createWorkoutSession,
        _createSetSession = createSetSession,
        super(
          WorkoutSessionState(
            plan: _emptyPlan(),
          ),
        ) {
    on<StartWorkoutPlan>(_onStartWorkoutPlan);
    on<WorkoutSessionCreated>(_onWorkoutSessionCreated);
    on<CompleteCurrentSet>(_onCompleteCurrentSet);
    on<SkipRestTimer>(_onSkipRestTimer);
    on<AddRestTime>(_onAddRestTime);
    on<SkipCurrentExercise>(_onSkipCurrentExercise);
    on<PauseWorkout>(_onPauseWorkout);
    on<ResumeWorkout>(_onResumeWorkout);
    on<FinishWorkoutEarly>(_onFinishWorkoutEarly);
    on<SaveAndFinishWorkout>(_onSaveAndFinishWorkout);

    // internal ticks
    on<TimerTick>(_onTimerTick);
    on<RestTimerTick>(_onRestTimerTick);
    on<RestTimerExpired>(_onRestTimerExpired);
  }

  @override
  Future<void> close() {
    _cancelTimers();
    return super.close();
  }

  void _cancelTimers() {
    _elapsedTimer?.cancel();
    _elapsedTimer = null;
    _restTimer?.cancel();
    _restTimer = null;
  }

  void _startElapsedTimer() {
    _elapsedTimer?.cancel();
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const TimerTick());
    });
  }

  void _startRestTimer(int seconds) {
    _restTimer?.cancel();
    var remaining = seconds;
    add(RestTimerTick(remaining));
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining--;
      if (remaining <= 0) {
        timer.cancel();
        add(const RestTimerExpired());
      } else {
        add(RestTimerTick(remaining));
      }
    });
  }

  void _onStartWorkoutPlan(
    StartWorkoutPlan event,
    Emitter<WorkoutSessionState> emit,
  ) {
    _cancelTimers();
    emit(WorkoutSessionState(
      plan: event.plan,
      status: WorkoutStatus.running,
      currentExerciseIndex: 0,
      currentSetNumber: 1,
      elapsedSeconds: 0,
      completedSets: const [],
    ));
    _startElapsedTimer();
  }

  void _onWorkoutSessionCreated(
    WorkoutSessionCreated event,
    Emitter<WorkoutSessionState> emit,
  ) {
    emit(state.copyWith(sessionId: event.session.workoutSessionId));
  }

  void _onCompleteCurrentSet(
    CompleteCurrentSet event,
    Emitter<WorkoutSessionState> emit,
  ) {
    final currentEx = state.currentPlanExercise;
    if (currentEx == null) return;

    final newCompletedSet = CompletedSetData(
      exerciseId: currentEx.exerciseId,
      exerciseName: currentEx.exercise?.name ?? 'Exercise ${state.currentExerciseIndex + 1}',
      setNumber: state.currentSetNumber,
      repsCompleted: event.repsCompleted,
      weightUsed: event.weightUsed,
      isSkipped: false,
    );

    final updatedCompletedSets = List<CompletedSetData>.from(state.completedSets)
      ..add(newCompletedSet);

    final totalSets = state.totalSetsCompleted + 1;
    final totalReps = state.totalRepsCompleted + event.repsCompleted;


    final restSeconds = 60; // Standard 60 seconds rest

    final isLastSet = state.isLastSetOfCurrentExercise;
    final isLastExercise = state.isLastExercise;

    if (restSeconds > 0) {
      emit(state.copyWith(
        status: WorkoutStatus.resting,
        totalSetsCompleted: totalSets,
        totalRepsCompleted: totalReps,
        completedSets: updatedCompletedSets,
        restSecondsRemaining: restSeconds,
      ));
      _startRestTimer(restSeconds);
    } else {
      _advanceToNextStep(
        emit: emit,
        totalSets: totalSets,
        totalReps: totalReps,
        completedSets: updatedCompletedSets,
        isLastSet: isLastSet,
        isLastExercise: isLastExercise,
      );
    }
  }

  void _onSkipRestTimer(
    SkipRestTimer event,
    Emitter<WorkoutSessionState> emit,
  ) {
    _restTimer?.cancel();
    _restTimer = null;

    final isLastSet = state.isLastSetOfCurrentExercise;
    final isLastExercise = state.isLastExercise;

    _advanceToNextStep(
      emit: emit,
      totalSets: state.totalSetsCompleted,
      totalReps: state.totalRepsCompleted,
      completedSets: state.completedSets,
      isLastSet: isLastSet,
      isLastExercise: isLastExercise,
    );
  }

  void _onAddRestTime(
    AddRestTime event,
    Emitter<WorkoutSessionState> emit,
  ) {
    if (state.status != WorkoutStatus.resting) return;
    final current = state.restSecondsRemaining ?? 0;
    final newTime = current + event.seconds;
    _startRestTimer(newTime);
  }

  void _onRestTimerExpired(
    RestTimerExpired event,
    Emitter<WorkoutSessionState> emit,
  ) {
    _restTimer = null;
    final isLastSet = state.isLastSetOfCurrentExercise;
    final isLastExercise = state.isLastExercise;

    _advanceToNextStep(
      emit: emit,
      totalSets: state.totalSetsCompleted,
      totalReps: state.totalRepsCompleted,
      completedSets: state.completedSets,
      isLastSet: isLastSet,
      isLastExercise: isLastExercise,
    );
  }

  void _advanceToNextStep({
    required Emitter<WorkoutSessionState> emit,
    required int totalSets,
    required int totalReps,
    required List<CompletedSetData> completedSets,
    required bool isLastSet,
    required bool isLastExercise,
  }) {
    if (isLastSet && isLastExercise) {
      _restTimer?.cancel();
      _restTimer = null;
      emit(state.copyWith(
        status: WorkoutStatus.summary,
        totalSetsCompleted: totalSets,
        totalRepsCompleted: totalReps,
        completedSets: completedSets,
        clearRestTimer: true,
      ));
    } else if (isLastSet) {
      // Advance to Next Exercise, Set 1
      emit(state.copyWith(
        status: WorkoutStatus.running,
        currentExerciseIndex: state.currentExerciseIndex + 1,
        currentSetNumber: 1,
        totalSetsCompleted: totalSets,
        totalRepsCompleted: totalReps,
        completedSets: completedSets,
        clearRestTimer: true,
      ));
    } else {
      // Advance to Next Set of Current Exercise
      emit(state.copyWith(
        status: WorkoutStatus.running,
        currentSetNumber: state.currentSetNumber + 1,
        totalSetsCompleted: totalSets,
        totalRepsCompleted: totalReps,
        completedSets: completedSets,
        clearRestTimer: true,
      ));
    }
  }

  void _onSkipCurrentExercise(
    SkipCurrentExercise event,
    Emitter<WorkoutSessionState> emit,
  ) {
    _restTimer?.cancel();
    _restTimer = null;

    final currentEx = state.currentPlanExercise;
    final updatedCompletedSets = List<CompletedSetData>.from(state.completedSets);
    if (currentEx != null) {
      for (int s = state.currentSetNumber; s <= currentEx.targetSets; s++) {
        updatedCompletedSets.add(CompletedSetData(
          exerciseId: currentEx.exerciseId,
          exerciseName: currentEx.exercise?.name ?? 'Exercise ${state.currentExerciseIndex + 1}',
          setNumber: s,
          repsCompleted: 0,
          weightUsed: 0,
          isSkipped: true,
        ));
      }
    }

    if (state.isLastExercise) {
      emit(state.copyWith(
        status: WorkoutStatus.summary,
        completedSets: updatedCompletedSets,
        clearRestTimer: true,
      ));
    } else {
      emit(state.copyWith(
        status: WorkoutStatus.running,
        currentExerciseIndex: state.currentExerciseIndex + 1,
        currentSetNumber: 1,
        completedSets: updatedCompletedSets,
        clearRestTimer: true,
      ));
    }
  }

  void _onPauseWorkout(PauseWorkout event, Emitter<WorkoutSessionState> emit) {
    if (state.status == WorkoutStatus.paused) return;
    _statusBeforePause = state.status;
    _elapsedTimer?.cancel();
    _restTimer?.cancel();
    emit(state.copyWith(status: WorkoutStatus.paused));
  }

  void _onResumeWorkout(
    ResumeWorkout event,
    Emitter<WorkoutSessionState> emit,
  ) {
    if (state.status != WorkoutStatus.paused) return;
    final resumeStatus = _statusBeforePause == WorkoutStatus.resting
        ? WorkoutStatus.resting
        : WorkoutStatus.running;

    emit(state.copyWith(status: resumeStatus));
    _startElapsedTimer();
    if (resumeStatus == WorkoutStatus.resting &&
        state.restSecondsRemaining != null &&
        state.restSecondsRemaining! > 0) {
      _startRestTimer(state.restSecondsRemaining!);
    }
  }

  void _onFinishWorkoutEarly(
    FinishWorkoutEarly event,
    Emitter<WorkoutSessionState> emit,
  ) {
    _cancelTimers();
    emit(state.copyWith(
      status: WorkoutStatus.summary,
      clearRestTimer: true,
    ));
  }

  Future<void> _onSaveAndFinishWorkout(
    SaveAndFinishWorkout event,
    Emitter<WorkoutSessionState> emit,
  ) async {

    final authService = AuthServices();
    try {
      final now = DateTime.now();
      final startTime = now.subtract(Duration(seconds: state.elapsedSeconds));

      final session = WorkoutSessionEntity(
        userId: state.plan.userId ?? authService.user!.id,
        planId: state.plan.planId,
        planName: state.plan.planName.isNotEmpty ? state.plan.planName : 'Workout Session',
        dateTracked: now,
        startedAt: startTime,
        completedAt: now,
      );

      final createdSessionId = await _createWorkoutSession(session);

      // Save session sets
      for (final set in state.completedSets) {
        if (!set.isSkipped) {
          final setSession = SetSessionEntity(
            setSessionId: '${createdSessionId}_${set.exerciseId}_${set.setNumber}',
            workoutSessionId: createdSessionId,
            exerciseId: set.exerciseId,
            setNumber: set.setNumber,
            repsPerformed: set.repsCompleted,
            weight: set.weightUsed,
            isCompleted: true,
          );
          await _createSetSession(setSession);
        }
      }

      _cancelTimers();
      emit(state.copyWith(
        status: WorkoutStatus.finished,
        sessionId: createdSessionId,
      ));
    } catch (e) {
      _cancelTimers();
      emit(state.copyWith(status: WorkoutStatus.finished));
    }
  }

  void _onTimerTick(TimerTick event, Emitter<WorkoutSessionState> emit) {
    if (state.status == WorkoutStatus.running ||
        state.status == WorkoutStatus.resting) {
      emit(state.copyWith(elapsedSeconds: state.elapsedSeconds + 1));
    }
  }

  void _onRestTimerTick(
    RestTimerTick event,
    Emitter<WorkoutSessionState> emit,
  ) {
    emit(state.copyWith(restSecondsRemaining: event.remaining));
  }
}

