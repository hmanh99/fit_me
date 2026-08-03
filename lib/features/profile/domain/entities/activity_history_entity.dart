import 'package:equatable/equatable.dart';

class ActivityHistoryEntity extends Equatable {
  final int workoutSessionId;
  final String userId;
  final int planId;
  final String planName;
  final DateTime dateTracked;
  final DateTime startedAt;
  final DateTime completedAt;

  const ActivityHistoryEntity({
    required this.workoutSessionId,
    required this.userId,
    required this.planId,
    required this.planName,
    required this.dateTracked,
    required this.startedAt,
    required this.completedAt,
  });


  Duration get duration {
    return completedAt.difference(startedAt);
  }

  ActivityHistoryEntity copyWith({
    int? workoutSessionId,
    String? userId,
    int? planId,
    String? planName,
    DateTime? dateTracked,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return ActivityHistoryEntity(
      workoutSessionId: workoutSessionId ?? this.workoutSessionId,
      userId: userId ?? this.userId,
      planId: planId ?? this.planId,
      planName: planName ?? this.planName,
      dateTracked: dateTracked ?? this.dateTracked,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
    workoutSessionId,
    userId,
    planId,
    planName,
    dateTracked,
    startedAt,
    completedAt,
  ];
}
