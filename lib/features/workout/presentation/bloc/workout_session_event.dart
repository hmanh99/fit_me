import 'package:equatable/equatable.dart';
import 'package:fit_me/features/workout/domain/entities/workout_plan_entity.dart';
import 'package:fit_me/features/workout/domain/entities/workout_session_entity.dart';

abstract class WorkoutSessionEvent extends Equatable {
  const WorkoutSessionEvent();

  @override
  List<Object?> get props => [];
}

/// initialize workout session using a plan
class StartWorkoutPlan extends WorkoutSessionEvent {
  final WorkoutPlanEntity plan;

  const StartWorkoutPlan({required this.plan});

  @override
  List<Object?> get props => [plan];
}

class WorkoutSessionCreated extends WorkoutSessionEvent {
  final WorkoutSessionEntity session;

  const WorkoutSessionCreated({required this.session});

  @override
  List<Object?> get props => [session];
}

class CompleteCurrentSet extends WorkoutSessionEvent {
  final int repsCompleted;
  final double? weightUsed;

  const CompleteCurrentSet({required this.repsCompleted, this.weightUsed});

  @override
  List<Object?> get props => [repsCompleted, weightUsed];
}

/// Skip rest timer
class SkipRestTimer extends WorkoutSessionEvent {
  const SkipRestTimer();
}

/// Add extra rest time in seconds (+30s)
class AddRestTime extends WorkoutSessionEvent {
  final int seconds;

  const AddRestTime({this.seconds = 30});

  @override
  List<Object?> get props => [seconds];
}

/// Skip
class SkipCurrentExercise extends WorkoutSessionEvent {
  const SkipCurrentExercise();
}

/// Pause / Resume
class PauseWorkout extends WorkoutSessionEvent {
  const PauseWorkout();
}

class ResumeWorkout extends WorkoutSessionEvent {
  const ResumeWorkout();
}

/// Finish Early
class FinishWorkoutEarly extends WorkoutSessionEvent {
  const FinishWorkoutEarly();
}

/// Save & Finish
class SaveAndFinishWorkout extends WorkoutSessionEvent {
  const SaveAndFinishWorkout();
}

/// Tickers
class TimerTick extends WorkoutSessionEvent {
  const TimerTick();
}

class RestTimerTick extends WorkoutSessionEvent {
  final int remaining;

  const RestTimerTick(this.remaining);

  @override
  List<Object?> get props => [remaining];
}

class RestTimerExpired extends WorkoutSessionEvent {
  const RestTimerExpired();
}
