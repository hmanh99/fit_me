import 'package:equatable/equatable.dart';
import 'package:fit_me/features/profile/domain/entities/activity_history_entity.dart';

abstract class ActivityHistoryState extends Equatable {
  const ActivityHistoryState();

  @override
  List<Object?> get props => [];
}

class ActivityHistoryInitial extends ActivityHistoryState {}

class ActivityHistoryLoading extends ActivityHistoryState {}

class ActivityHistoryLoaded extends ActivityHistoryState {
  final List<ActivityHistoryEntity> histories;
  final Map<String, List<ActivityHistoryEntity>> groupedHistories;
  final Map<DateTime, int> heatmapCounts;
  final int heatmapDays;

  const ActivityHistoryLoaded({
    required this.histories,
    required this.groupedHistories,
    this.heatmapCounts = const {},
    this.heatmapDays = 365,
  });

  ActivityHistoryLoaded copyWith({
    List<ActivityHistoryEntity>? histories,
    Map<String, List<ActivityHistoryEntity>>? groupedHistories,
    Map<DateTime, int>? heatmapCounts,
    int? heatmapDays,
  }) {
    return ActivityHistoryLoaded(
      histories: histories ?? this.histories,
      groupedHistories: groupedHistories ?? this.groupedHistories,
      heatmapCounts: heatmapCounts ?? this.heatmapCounts,
      heatmapDays: heatmapDays ?? this.heatmapDays,
    );
  }

  @override
  List<Object?> get props => [histories, groupedHistories, heatmapCounts, heatmapDays];
}

class ActivityHistoryEmpty extends ActivityHistoryState {}

class ActivityHistoryError extends ActivityHistoryState {
  final String message;

  const ActivityHistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
