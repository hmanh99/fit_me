import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_fitness_tracker/features/schedule/domain/entities/workout_schedule_entity.dart';
import 'package:personal_fitness_tracker/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:personal_fitness_tracker/features/schedule/presentation/bloc/schedule_event.dart';
import 'package:personal_fitness_tracker/features/schedule/presentation/bloc/schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleRepository scheduleRepository;
  StreamSubscription<List<WorkoutScheduleEntity>>? _realtimeSub;

  ScheduleBloc({required this.scheduleRepository})
      : super(ScheduleState.initial()) {
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
      final schedules = await scheduleRepository.getSchedulesByMonth(
        userId: event.userId,
        year: event.year,
        month: event.month,
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
      await scheduleRepository.addSchedule(event.schedule);

      // Re-fetch the current month to get the server-assigned ID
      await _refreshCurrentMonth(emit);

      emit(state.copyWith(operationStatus: ScheduleOperationStatus.success));
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
      await scheduleRepository.updateSchedule(event.schedule);
      await _refreshCurrentMonth(emit);
      emit(state.copyWith(operationStatus: ScheduleOperationStatus.success));
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
      await scheduleRepository.deleteSchedule(event.scheduleId);
      await _refreshCurrentMonth(emit);
      emit(state.copyWith(operationStatus: ScheduleOperationStatus.success));
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
    emit(state.copyWith(operationStatus: ScheduleOperationStatus.idle));
  }


  //     Helpers
  /// Re-fetch schedules for the currently focused month and update state.
  Future<void> _refreshCurrentMonth(Emitter<ScheduleState> emit) async {
    if (state.userId == null) return;

    final schedules = await scheduleRepository.getSchedulesByMonth(
      userId: state.userId!,
      year: state.focusedDate.year,
      month: state.focusedDate.month,
    );

    final marked = _buildMarkedDates(schedules);
    final selectedDayItems = _filterByDate(schedules, state.selectedDate);

    emit(state.copyWith(
      allSchedules: schedules,
      markedDates: marked,
      selectedDateSchedules: selectedDayItems,
    ));
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
    _realtimeSub = scheduleRepository.watchSchedules(userId).listen(
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
