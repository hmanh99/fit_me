import 'package:equatable/equatable.dart';
import 'package:fit_me/features/schedule/domain/entities/schedule_status.dart';

/// Domain entity representing a single scheduled workout.
class WorkoutScheduleEntity extends Equatable {
  final int scheduleId;
  final String userId;
  final int? planId;
  final String planName;
  final DateTime scheduleDate;
  final String? note;
  final ScheduleStatus status;
  final DateTime createdAt;

  const WorkoutScheduleEntity({
    required this.scheduleId,
    required this.userId,
    required this.planName,
    required this.scheduleDate,
    required this.status,
    required this.createdAt,
    this.planId,
    this.note,
  });

  WorkoutScheduleEntity copyWith({
    int? scheduleId,
    String? userId,
    int? planId,
    String? planName,
    DateTime? scheduleDate,
    String? note,
    ScheduleStatus? status,
    DateTime? createdAt,
  }) {
    return WorkoutScheduleEntity(
      scheduleId: scheduleId ?? this.scheduleId,
      userId: userId ?? this.userId,
      planId: planId ?? this.planId,
      planName: planName ?? this.planName,
      scheduleDate: scheduleDate ?? this.scheduleDate,
      note: note ?? this.note,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        scheduleId,
        userId,
        planId,
        planName,
        scheduleDate,
        note,
        status,
        createdAt,
      ];

  @override
  String toString() =>
      'WorkoutScheduleEntity(id: $scheduleId, plan: $planName, '
      'date: $scheduleDate, status: $status)';
}
