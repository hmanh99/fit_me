import 'package:equatable/equatable.dart';

abstract class ActivityHistoryEvent extends Equatable {
  const ActivityHistoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchActivityHistory extends ActivityHistoryEvent {
  final String userId;

  const FetchActivityHistory({required this.userId});

  @override
  List<Object?> get props => [userId];
}

