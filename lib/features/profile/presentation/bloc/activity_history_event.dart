import 'package:equatable/equatable.dart';

abstract class ActivityHistoryEvent extends Equatable {
  const ActivityHistoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchActivityHistory extends ActivityHistoryEvent {
  final String userId;
  final int heatmapDays;

  const FetchActivityHistory({
    required this.userId,
    this.heatmapDays = 365,
  });

  @override
  List<Object?> get props => [userId, heatmapDays];
}

class FetchActivityHeatmap extends ActivityHistoryEvent {
  final String userId;
  final int days;

  const FetchActivityHeatmap({
    required this.userId,
    this.days = 365,
  });

  @override
  List<Object?> get props => [userId, days];
}
