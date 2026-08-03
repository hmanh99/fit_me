import 'package:equatable/equatable.dart';
import 'package:personal_fitness_tracker/features/profile/domain/entities/activity_history_entity.dart';

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

  const ActivityHistoryLoaded({
    required this.histories,
    required this.groupedHistories,
  });

  @override
  List<Object?> get props => [histories, groupedHistories];
}

class ActivityHistoryEmpty extends ActivityHistoryState {}

class ActivityHistoryError extends ActivityHistoryState {
  final String message;

  const ActivityHistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
