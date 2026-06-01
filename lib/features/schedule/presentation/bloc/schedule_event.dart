import 'package:equatable/equatable.dart';
import 'package:personal_fitness_tracker/features/schedule/domain/entities/workout_schedule_entity.dart';

/// Base class for all schedule events.
abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

/// Load all schedules for a given month.
class ScheduleLoadRequested extends ScheduleEvent {
  final String userId;
  final int year;
  final int month;

  const ScheduleLoadRequested({
    required this.userId,
    required this.year,
    required this.month,
  });

  @override
  List<Object?> get props => [userId, year, month];
}

/// User tapped a date on the calendar.
class ScheduleDateSelected extends ScheduleEvent {
  final DateTime selectedDate;

  const ScheduleDateSelected({required this.selectedDate});

  @override
  List<Object?> get props => [selectedDate];
}

/// Add a new schedule entry.
class ScheduleAddRequested extends ScheduleEvent {
  final WorkoutScheduleEntity schedule;

  const ScheduleAddRequested({required this.schedule});

  @override
  List<Object?> get props => [schedule];
}

/// Update an existing schedule entry.
class ScheduleUpdateRequested extends ScheduleEvent {
  final WorkoutScheduleEntity schedule;

  const ScheduleUpdateRequested({required this.schedule});

  @override
  List<Object?> get props => [schedule];
}

/// Delete a schedule by its ID.
class ScheduleDeleteRequested extends ScheduleEvent {
  final int scheduleId;

  const ScheduleDeleteRequested({required this.scheduleId});

  @override
  List<Object?> get props => [scheduleId];
}

/// Fired internally when the realtime stream emits new data.
class ScheduleRealtimeUpdated extends ScheduleEvent {
  final List<WorkoutScheduleEntity> schedules;

  const ScheduleRealtimeUpdated({required this.schedules});

  @override
  List<Object?> get props => [schedules];
}

/// Reset the operation status back to idle after showing a snackbar.
class ScheduleOperationStatusReset extends ScheduleEvent {
  const ScheduleOperationStatusReset();
}
