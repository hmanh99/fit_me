import 'package:equatable/equatable.dart';
import 'package:fit_me/features/workout/domain/entities/plan_exercise_entity.dart';
import 'package:fit_me/features/workout/domain/entities/workout_plan_entity.dart';

enum WorkoutStatus { initial, running, resting, paused, summary, finished }

/// Tracks a single completed set for the summary.
class CompletedSetData extends Equatable {
  final int exerciseId;
  final String exerciseName;
  final int setNumber;
  final int repsCompleted;
  final double? weightUsed;
  final bool isSkipped;

  const CompletedSetData({
    required this.exerciseId,
    required this.exerciseName,
    required this.setNumber,
    required this.repsCompleted,
    this.weightUsed,
    this.isSkipped = false,
  });

  @override
  List<Object?> get props =>
      [exerciseId, exerciseName, setNumber, repsCompleted, weightUsed, isSkipped];
}

class WorkoutSessionState extends Equatable {
  final WorkoutPlanEntity plan;
  final WorkoutStatus status;
  final int currentExerciseIndex;
  final int currentSetNumber;
  final int elapsedSeconds;
  final int? restSecondsRemaining;
  final int? sessionId;
  final int totalSetsCompleted;
  final int totalRepsCompleted;
  final List<CompletedSetData> completedSets;

  const WorkoutSessionState({
    this.status = WorkoutStatus.initial,
    required this.plan,
    this.currentExerciseIndex = 0,
    this.currentSetNumber = 1,
    this.elapsedSeconds = 0,
    this.restSecondsRemaining,
    this.sessionId,
    this.totalSetsCompleted = 0,
    this.totalRepsCompleted = 0,
    this.completedSets = const [],
  });

  // ── derived getters ──

  PlanExerciseEntity? get currentPlanExercise {
    if (plan.planExercises.isEmpty) return null;
    if (currentExerciseIndex < 0 ||
        currentExerciseIndex >= plan.planExercises.length) {
      return null;
    }
    return plan.planExercises[currentExerciseIndex];
  }

  PlanExerciseEntity? get nextPlanExercise {
    final nextIndex = isLastSetOfCurrentExercise
        ? currentExerciseIndex + 1
        : currentExerciseIndex;
    if (nextIndex < 0 || nextIndex >= plan.planExercises.length) {
      return null;
    }
    return plan.planExercises[nextIndex];
  }

  int get totalExercises => plan.planExercises.length;

  int get totalSetsInPlan =>
      plan.planExercises.fold(0, (sum, e) => sum + e.targetSets);

  double get progress {
    if (totalSetsInPlan == 0) return 0;
    return (totalSetsCompleted / totalSetsInPlan).clamp(0.0, 1.0);
  }

  bool get isLastExercise =>
      currentExerciseIndex >= plan.planExercises.length - 1;

  bool get isLastSetOfCurrentExercise {
    final currentEx = currentPlanExercise;
    if (currentEx == null) return true;
    return currentSetNumber >= currentEx.targetSets;
  }

  double get totalVolume {
    return completedSets.fold(0.0, (sum, set) {
      final weight = set.weightUsed ?? 0.0;
      return sum + (weight * set.repsCompleted);
    });
  }

  // ── copyWith ──

  WorkoutSessionState copyWith({
    WorkoutStatus? status,
    WorkoutPlanEntity? plan,
    int? currentExerciseIndex,
    int? currentSetNumber,
    int? elapsedSeconds,
    int? restSecondsRemaining,
    bool clearRestTimer = false,
    int? sessionId,
    int? totalSetsCompleted,
    int? totalRepsCompleted,
    List<CompletedSetData>? completedSets,
  }) {
    return WorkoutSessionState(
      status: status ?? this.status,
      plan: plan ?? this.plan,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      currentSetNumber: currentSetNumber ?? this.currentSetNumber,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      restSecondsRemaining: clearRestTimer
          ? null
          : (restSecondsRemaining ?? this.restSecondsRemaining),
      sessionId: sessionId ?? this.sessionId,
      totalSetsCompleted: totalSetsCompleted ?? this.totalSetsCompleted,
      totalRepsCompleted: totalRepsCompleted ?? this.totalRepsCompleted,
      completedSets: completedSets ?? this.completedSets,
    );
  }

  @override
  List<Object?> get props => [
        status,
        plan,
        currentExerciseIndex,
        currentSetNumber,
        elapsedSeconds,
        restSecondsRemaining,
        sessionId,
        totalSetsCompleted,
        totalRepsCompleted,
        completedSets,
      ];
}

