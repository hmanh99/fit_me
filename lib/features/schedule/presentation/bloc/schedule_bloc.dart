import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fit_me/features/schedule/domain/entities/workout_schedule_entity.dart';
import 'package:fit_me/features/schedule/domain/usecases/add_schedule_use_case.dart';
import 'package:fit_me/features/schedule/domain/usecases/delete_schedule_use_case.dart';
import 'package:fit_me/features/schedule/domain/usecases/get_schedules_by_month_use_case.dart';
import 'package:fit_me/features/schedule/domain/usecases/update_schedule_use_case.dart';
import 'package:fit_me/features/schedule/domain/usecases/watch_schedules_use_case.dart';
import 'package:fit_me/features/schedule/presentation/bloc/schedule_event.dart';
import 'package:fit_me/features/schedule/presentation/bloc/schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final GetSchedulesByMonthUseCase _getSchedulesByMonth;
  final AddScheduleUseCase _addSchedule;
  final UpdateScheduleUseCase _updateSchedule;
  final DeleteScheduleUseCase _deleteSchedule;
  final WatchSchedulesUseCase _watchSchedules;
  StreamSubscription<List<WorkoutScheduleEntity>>? _realtimeSub;

  ScheduleBloc({
    required GetSchedulesByMonthUseCase getSchedulesByMonth,
    required AddScheduleUseCase addSchedule,
    required UpdateScheduleUseCase updateSchedule,
    required DeleteScheduleUseCase deleteSchedule,
    required WatchSchedulesUseCase watchSchedules,
  })  : _getSchedulesByMonth = getSchedulesByMonth,
        _addSchedule = addSchedule,
        _updateSchedule = updateSchedule,
        _deleteSchedule = deleteSchedule,
        _watchSchedules = watchSchedules,
        super(ScheduleState.initial()) {
    on<ScheduleLoadRequested>(_onLoadRequested);
    on<ScheduleDateSelected>(_onDateSelected);
    on<ScheduleAddRequested>(_onAddRequested);
    on<ScheduleUpdateRequested>(_onUpdateRequested);
    on<ScheduleDeleteRequested>(_onDeleteRequested);
    on<ScheduleRealtimeUpdated>(_onRealtimeUpdated);
    on<ScheduleOperationStatusReset>(_onOperationStatusReset);
  }

  ///    Load schedules for a month
  Future<void> _onLoadRequested(
    ScheduleLoadRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(
      status: ScheduleStateStatus.loading,
      userId: event.userId,
    ));

    try {
      final schedules = await _getSchedulesByMonth(
        GetSchedulesByMonthParams(
          userId: event.userId,
          year: event.year,
          month: event.month,
        ),
      );

      final marked = _buildMarkedDates(schedules);
      final selectedDayItems = _filterByDate(schedules, state.selectedDate);

      emit(state.copyWith(
        status: ScheduleStateStatus.loaded,
        allSchedules: schedules,
        markedDates: marked,
        selectedDateSchedules: selectedDayItems,
        focusedDate: DateTime(event.year, event.month),
      ));

      // Start realtime subscription
      _startRealtimeSubscription(event.userId);
    } catch (e) {
      emit(state.copyWith(
        status: ScheduleStateStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  ///    Date tapped on calendar
  void _onDateSelected(
    ScheduleDateSelected event,
    Emitter<ScheduleState> emit,
  ) {
    final selected = _normalizeDate(event.selectedDate);
    final filtered = _filterByDate(state.allSchedules, selected);

    emit(state.copyWith(
      selectedDate: selected,
      selectedDateSchedules: filtered,
    ));
  }

  ///     Add schedule
  Future<void> _onAddRequested(
    ScheduleAddRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(operationStatus: ScheduleOperationStatus.loading));
    try {
      await _addSchedule(event.schedule);

      // Bug 2 fix: fetch the refreshed data first, then emit a single
      // atomic state that includes both the new list AND operationStatus
      // success — this prevents the stale-snapshot rollback.
      final refreshed = await _fetchCurrentMonthData();
      emit(state.copyWith(
        operationStatus: ScheduleOperationStatus.success,
        allSchedules: refreshed.schedules,
        markedDates: refreshed.marked,
        selectedDateSchedules: refreshed.selected,
        clearErrorMessage: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        operationStatus: ScheduleOperationStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  ///     Update schedule
  Future<void> _onUpdateRequested(
    ScheduleUpdateRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(operationStatus: ScheduleOperationStatus.loading));
    try {
      await _updateSchedule(event.schedule);

      // Bug 2 fix: single atomic emit with fresh data + success status.
      final refreshed = await _fetchCurrentMonthData();
      emit(state.copyWith(
        operationStatus: ScheduleOperationStatus.success,
        allSchedules: refreshed.schedules,
        markedDates: refreshed.marked,
        selectedDateSchedules: refreshed.selected,
        clearErrorMessage: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        operationStatus: ScheduleOperationStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  ///     Delete schedule
  Future<void> _onDeleteRequested(
    ScheduleDeleteRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(operationStatus: ScheduleOperationStatus.loading));
    try {
      await _deleteSchedule(event.scheduleId);

      // Bug 2 fix: single atomic emit with fresh data + success status.
      final refreshed = await _fetchCurrentMonthData();
      emit(state.copyWith(
        operationStatus: ScheduleOperationStatus.success,
        allSchedules: refreshed.schedules,
        markedDates: refreshed.marked,
        selectedDateSchedules: refreshed.selected,
        clearErrorMessage: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        operationStatus: ScheduleOperationStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  ///     Realtime update from stream
  void _onRealtimeUpdated(
    ScheduleRealtimeUpdated event,
    Emitter<ScheduleState> emit,
  ) {
    // Filter to only the currently focused month
    final focusedYear = state.focusedDate.year;
    final focusedMonth = state.focusedDate.month;

    final monthSchedules = event.schedules.where((s) {
      return s.scheduleDate.year == focusedYear &&
          s.scheduleDate.month == focusedMonth;
    }).toList();

    final marked = _buildMarkedDates(monthSchedules);
    final selectedDayItems = _filterByDate(monthSchedules, state.selectedDate);

    emit(state.copyWith(
      allSchedules: monthSchedules,
      markedDates: marked,
      selectedDateSchedules: selectedDayItems,
    ));
  }

  ///     Reset operation status
  void _onOperationStatusReset(
    ScheduleOperationStatusReset event,
    Emitter<ScheduleState> emit,
  ) {
    emit(state.copyWith(
      operationStatus: ScheduleOperationStatus.idle,
      clearErrorMessage: true,
    ));
  }


  //     Helpers

  /// Bug 2 fix: Returns a record with fresh schedule data for the currently
  /// focused month WITHOUT emitting any state. Callers compose a single
  /// atomic emit themselves to avoid stale-snapshot rollbacks.
  Future<
      ({
        List<WorkoutScheduleEntity> schedules,
        Map<DateTime, List<WorkoutScheduleEntity>> marked,
        List<WorkoutScheduleEntity> selected,
      })> _fetchCurrentMonthData() async {
    if (state.userId == null) {
      return (
        schedules: <WorkoutScheduleEntity>[],
        marked: <DateTime, List<WorkoutScheduleEntity>>{},
        selected: <WorkoutScheduleEntity>[],
      );
    }

    // Bug 5 fix: always use state.focusedDate (kept in sync by
    // _onLoadRequested) as the authoritative month source for CUD refreshes.
    final schedules = await _getSchedulesByMonth(
      GetSchedulesByMonthParams(
        userId: state.userId!,
        year: state.focusedDate.year,
        month: state.focusedDate.month,
      ),
    );

    return (
      schedules: schedules,
      marked: _buildMarkedDates(schedules),
      selected: _filterByDate(schedules, state.selectedDate),
    );
  }

  /// Build the marker map: normalised date → list of schedules.
  Map<DateTime, List<WorkoutScheduleEntity>> _buildMarkedDates(
    List<WorkoutScheduleEntity> schedules,
  ) {
    final map = <DateTime, List<WorkoutScheduleEntity>>{};
    for (final schedule in schedules) {
      final key = _normalizeDate(schedule.scheduleDate);
      map.putIfAbsent(key, () => []).add(schedule);
    }
    return map;
  }

  /// Filter schedules that match a given date.
  List<WorkoutScheduleEntity> _filterByDate(
    List<WorkoutScheduleEntity> schedules,
    DateTime date,
  ) {
    final normalised = _normalizeDate(date);
    return schedules
        .where((s) => _normalizeDate(s.scheduleDate) == normalised)
        .toList();
  }

  /// Strip time component for date-only comparison.
  DateTime _normalizeDate(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Subscribe to Supabase realtime;
  /// cancels previous subscription.
  /// automatic data update
  void _startRealtimeSubscription(String userId) {
    _realtimeSub?.cancel();
    _realtimeSub = _watchSchedules(userId).listen(
      (schedules) {
        add(ScheduleRealtimeUpdated(schedules: schedules));
      },
      onError: (_) {
        // Silently ignore realtime errors — the manual fetch is the source
        // of truth, and the user can always pull-to-refresh.
      },
    );
  }

  @override
  Future<void> close() {
    _realtimeSub?.cancel();
    return super.close();
  }
}
