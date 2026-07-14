import 'package:equatable/equatable.dart';
import 'package:personal_fitness_tracker/features/schedule/domain/entities/workout_schedule_entity.dart';

/// Loading status for the main data fetch.
enum ScheduleStateStatus { initial, loading, loaded, error }

/// Status for CUD operations (Create / Update / Delete).
enum ScheduleOperationStatus { idle, loading, success, failure }

/// Single-class state with [copyWith] to preserve calendar context
/// across state transitions.
class ScheduleState extends Equatable {
  /// All schedules for the currently viewed month.
  final List<WorkoutScheduleEntity> allSchedules;

  /// The date currently selected on the calendar.
  final DateTime selectedDate;

  /// The currently focused month (for calendar page control).
  final DateTime focusedDate;

  /// Schedules filtered for [selectedDate].
  final List<WorkoutScheduleEntity> selectedDateSchedules;

  /// Map of normalised dates → schedules for rendering markers.
  final Map<DateTime, List<WorkoutScheduleEntity>> markedDates;

  /// Overall data loading status.
  final ScheduleStateStatus status;

  /// Status of the latest CUD operation.
  final ScheduleOperationStatus operationStatus;

  /// Error message (when [status] == error or [operationStatus] == failure).
  final String? errorMessage;

  /// The current user ID loaded for.
  final String? userId;

  const ScheduleState({
    this.allSchedules = const [],
    required this.selectedDate,
    required this.focusedDate,
    this.selectedDateSchedules = const [],
    this.markedDates = const {},
    this.status = ScheduleStateStatus.initial,
    this.operationStatus = ScheduleOperationStatus.idle,
    this.errorMessage,
    this.userId,
  });

  /// Initial state with today as the selected/focused date.
  factory ScheduleState.initial() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return ScheduleState(
      selectedDate: today,
      focusedDate: today,
    );
  }

  ScheduleState copyWith({
    List<WorkoutScheduleEntity>? allSchedules,
    DateTime? selectedDate,
    DateTime? focusedDate,
    List<WorkoutScheduleEntity>? selectedDateSchedules,
    Map<DateTime, List<WorkoutScheduleEntity>>? markedDates,
    ScheduleStateStatus? status,
    ScheduleOperationStatus? operationStatus,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? userId,
  }) {
    return ScheduleState(
      allSchedules: allSchedules ?? this.allSchedules,
      selectedDate: selectedDate ?? this.selectedDate,
      focusedDate: focusedDate ?? this.focusedDate,
      selectedDateSchedules:
          selectedDateSchedules ?? this.selectedDateSchedules,
      markedDates: markedDates ?? this.markedDates,
      status: status ?? this.status,
      operationStatus: operationStatus ?? this.operationStatus,
      // Bug 1 fix: only overwrite errorMessage if explicitly provided or
      // clearErrorMessage is true; otherwise preserve the previous value.
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [
        allSchedules,
        selectedDate,
        focusedDate,
        selectedDateSchedules,
        markedDates,
        status,
        operationStatus,
        errorMessage,
        userId,
      ];
}
