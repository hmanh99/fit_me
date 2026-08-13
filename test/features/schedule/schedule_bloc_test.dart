import 'dart:async';
import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/features/schedule/domain/entities/schedule_status.dart';
import 'package:fit_me/features/schedule/domain/entities/workout_schedule_entity.dart';
import 'package:fit_me/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:fit_me/features/schedule/domain/usecases/add_schedule_use_case.dart';
import 'package:fit_me/features/schedule/domain/usecases/delete_schedule_use_case.dart';
import 'package:fit_me/features/schedule/domain/usecases/get_schedules_by_month_use_case.dart';
import 'package:fit_me/features/schedule/domain/usecases/update_schedule_use_case.dart';
import 'package:fit_me/features/schedule/domain/usecases/watch_schedules_use_case.dart';
import 'package:fit_me/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:fit_me/features/schedule/presentation/bloc/schedule_event.dart';
import 'package:fit_me/features/schedule/presentation/bloc/schedule_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

class MockScheduleRepository implements ScheduleRepository {
  Either<Failure, List<WorkoutScheduleEntity>> getByMonthResult =
      const Right([]);
  Either<Failure, void> addResult = const Right(null);
  Either<Failure, void> updateResult = const Right(null);
  Either<Failure, void> deleteResult = const Right(null);
  Stream<Either<Failure, List<WorkoutScheduleEntity>>> watchStream =
      const Stream.empty();

  @override
  Future<Either<Failure, List<WorkoutScheduleEntity>>> getSchedulesByMonth({
    required String userId,
    required int year,
    required int month,
  }) async =>
      getByMonthResult;

  @override
  Future<Either<Failure, List<WorkoutScheduleEntity>>> getSchedulesByDate({
    required String userId,
    required DateTime date,
  }) async =>
      const Right([]);

  @override
  Future<Either<Failure, void>> addSchedule({
    required WorkoutScheduleEntity schedule,
  }) async =>
      addResult;

  @override
  Future<Either<Failure, void>> updateSchedule({
    required WorkoutScheduleEntity schedule,
  }) async =>
      updateResult;

  @override
  Future<Either<Failure, void>> deleteSchedule({
    required int scheduleId,
  }) async =>
      deleteResult;

  @override
  Stream<Either<Failure, List<WorkoutScheduleEntity>>> watchSchedules({
    required String userId,
  }) =>
      watchStream;
}

void main() {
  late MockScheduleRepository mockRepo;
  late GetSchedulesByMonthUseCase getSchedulesByMonth;
  late AddScheduleUseCase addSchedule;
  late UpdateScheduleUseCase updateSchedule;
  late DeleteScheduleUseCase deleteSchedule;
  late WatchSchedulesUseCase watchSchedules;
  late ScheduleBloc bloc;

  final tSchedule = WorkoutScheduleEntity(
    scheduleId: 1,
    userId: 'user_123',
    planId: 10,
    planName: 'Leg Day',
    scheduleDate: DateTime(2026, 8, 15),
    status: ScheduleStatus.upcoming,
    createdAt: DateTime(2026, 8, 1),
  );

  setUp(() {
    mockRepo = MockScheduleRepository();
    getSchedulesByMonth = GetSchedulesByMonthUseCase(mockRepo);
    addSchedule = AddScheduleUseCase(mockRepo);
    updateSchedule = UpdateScheduleUseCase(mockRepo);
    deleteSchedule = DeleteScheduleUseCase(mockRepo);
    watchSchedules = WatchSchedulesUseCase(mockRepo);

    bloc = ScheduleBloc(
      getSchedulesByMonth: getSchedulesByMonth,
      addSchedule: addSchedule,
      updateSchedule: updateSchedule,
      deleteSchedule: deleteSchedule,
      watchSchedules: watchSchedules,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state has ScheduleStateStatus.initial', () {
    expect(bloc.state.status, equals(ScheduleStateStatus.initial));
  });

  test('ScheduleLoadRequested emits loaded state on success', () async {
    mockRepo.getByMonthResult = Right([tSchedule]);

    final expectedStates = [
      predicate<ScheduleState>(
        (s) => s.status == ScheduleStateStatus.loading && s.userId == 'user_123',
      ),
      predicate<ScheduleState>(
        (s) =>
            s.status == ScheduleStateStatus.loaded &&
            s.allSchedules.length == 1 &&
            s.markedDates.isNotEmpty,
      ),
    ];

    expectLater(bloc.stream, emitsInOrder(expectedStates));

    bloc.add(
      const ScheduleLoadRequested(userId: 'user_123', year: 2026, month: 8),
    );
  });

  test(
    'ScheduleLoadRequested emits error state on failure without throwing LateInitializationError',
    () async {
      mockRepo.getByMonthResult = Left(Failure('Database error'));

      final expectedStates = [
        predicate<ScheduleState>(
          (s) =>
              s.status == ScheduleStateStatus.loading && s.userId == 'user_123',
        ),
        predicate<ScheduleState>(
          (s) =>
              s.status == ScheduleStateStatus.error &&
              s.errorMessage == 'Database error',
        ),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(
        const ScheduleLoadRequested(userId: 'user_123', year: 2026, month: 8),
      );
    },
  );

  test('ScheduleAddRequested emits failure state on error', () async {
    mockRepo.addResult = Left(Failure('Insert failed'));

    final expectedStates = [
      predicate<ScheduleState>(
        (s) => s.operationStatus == ScheduleOperationStatus.loading,
      ),
      predicate<ScheduleState>(
        (s) =>
            s.operationStatus == ScheduleOperationStatus.failure &&
            s.errorMessage == 'Insert failed',
      ),
    ];

    expectLater(bloc.stream, emitsInOrder(expectedStates));

    bloc.add(ScheduleAddRequested(schedule: tSchedule));
  });

  test('ScheduleUpdateRequested emits failure state on error', () async {
    mockRepo.updateResult = Left(Failure('Update failed'));

    final expectedStates = [
      predicate<ScheduleState>(
        (s) => s.operationStatus == ScheduleOperationStatus.loading,
      ),
      predicate<ScheduleState>(
        (s) =>
            s.operationStatus == ScheduleOperationStatus.failure &&
            s.errorMessage == 'Update failed',
      ),
    ];

    expectLater(bloc.stream, emitsInOrder(expectedStates));

    bloc.add(ScheduleUpdateRequested(schedule: tSchedule));
  });

  test('ScheduleDeleteRequested emits failure state on error', () async {
    mockRepo.deleteResult = Left(Failure('Delete failed'));

    final expectedStates = [
      predicate<ScheduleState>(
        (s) => s.operationStatus == ScheduleOperationStatus.loading,
      ),
      predicate<ScheduleState>(
        (s) =>
            s.operationStatus == ScheduleOperationStatus.failure &&
            s.errorMessage == 'Delete failed',
      ),
    ];

    expectLater(bloc.stream, emitsInOrder(expectedStates));

    bloc.add(const ScheduleDeleteRequested(scheduleId: 1));
  });
}
