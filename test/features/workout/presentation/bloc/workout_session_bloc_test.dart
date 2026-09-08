import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/features/workout/domain/entities/plan_exercise_entity.dart';
import 'package:fit_me/features/workout/domain/entities/set_session_entity.dart';
import 'package:fit_me/features/workout/domain/entities/workout_plan_entity.dart';
import 'package:fit_me/features/workout/domain/entities/workout_session_entity.dart';
import 'package:fit_me/features/workout/domain/repositories/workout_repository.dart';
import 'package:fit_me/features/workout/domain/usecases/create_set_session_use_case.dart';
import 'package:fit_me/features/workout/domain/usecases/create_workout_session_use_case.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_session_bloc.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_session_event.dart';
import 'package:fit_me/features/workout/presentation/bloc/workout_session_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  test('keeps the workout summary open when session persistence fails', () async {
    final bloc = WorkoutSessionBloc(
      createWorkoutSession: CreateWorkoutSessionUseCase(
        _FailingWorkoutRepository(),
      ),
      createSetSession: CreateSetSessionUseCase(_FailingWorkoutRepository()),
    );
    addTearDown(bloc.close);

    final saveFailure = bloc.stream.firstWhere(
      (state) => state.saveErrorMessage == 'Session service unavailable.',
    );

    bloc
      ..add(StartWorkoutPlan(plan: _plan))
      ..add(const FinishWorkoutEarly())
      ..add(const SaveAndFinishWorkout());

    final state = await saveFailure;
    expect(state.status, WorkoutStatus.summary);
    expect(state.isSaving, isFalse);
    expect(state.sessionId, isNull);
  });

  test('records the configured exercise name and ignores a duplicate set tap',
      () async {
    final bloc = WorkoutSessionBloc(
      createWorkoutSession: CreateWorkoutSessionUseCase(
        _FailingWorkoutRepository(),
      ),
      createSetSession: CreateSetSessionUseCase(_FailingWorkoutRepository()),
    );
    addTearDown(bloc.close);

    final restingState = bloc.stream.firstWhere(
      (state) => state.status == WorkoutStatus.resting,
    );
    bloc
      ..add(StartWorkoutPlan(plan: _plan))
      ..add(const CompleteCurrentSet(repsCompleted: 10, weightUsed: 20));

    final state = await restingState;
    expect(state.completedSets.single.exerciseName, 'Bench press');

    bloc.add(const CompleteCurrentSet(repsCompleted: 10, weightUsed: 20));
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.totalSetsCompleted, 1);
  });
}

final _plan = WorkoutPlanEntity(
  planId: 1,
  userId: 'user-1',
  planName: 'Upper body',
  createdAt: DateTime(2026),
  planExercises: const [
    PlanExerciseEntity(
      planExerciseId: 1,
      planId: 1,
      exerciseId: 1,
      exerciseName: 'Bench press',
      orderInWorkout: 1,
      targetSets: 3,
      targetRepsOrSeconds: 10,
      musclesGroup: ['Chest'],
    ),
  ],
);

class _FailingWorkoutRepository implements WorkoutRepository {
  @override
  Future<Either<Failure, WorkoutPlanEntity>> createWorkoutPlan(
    WorkoutPlanEntity plan,
  ) => Future.value(Left(Failure()));

  @override
  Future<Either<Failure, int>> createWorkoutSession(
    WorkoutSessionEntity session,
  ) => Future.value(Left(Failure('Session service unavailable.')));

  @override
  Future<Either<Failure, void>> createSetSession(SetSessionEntity setSession) =>
      Future.value(Left(Failure()));

  @override
  Future<Either<Failure, void>> deleteWorkoutPlan(int planId) =>
      Future.value(Left(Failure()));

  @override
  Future<Either<Failure, WorkoutPlanEntity>> getWorkoutPlanDetails(int planId) =>
      Future.value(Left(Failure()));

  @override
  Future<Either<Failure, List<WorkoutPlanEntity>>> getWorkoutPlans(
    String? userId,
  ) => Future.value(Left(Failure()));

  @override
  Future<Either<Failure, WorkoutPlanEntity>> updateWorkoutPlan(
    WorkoutPlanEntity plan,
  ) => Future.value(Left(Failure()));
}
