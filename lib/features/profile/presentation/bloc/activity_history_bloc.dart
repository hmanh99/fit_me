import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_fitness_tracker/features/profile/domain/entities/activity_history_entity.dart';
import 'package:personal_fitness_tracker/features/profile/domain/usecases/get_activity_histories_use_case.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/bloc/activity_history_event.dart';
import 'package:personal_fitness_tracker/features/profile/presentation/bloc/activity_history_state.dart';

class ActivityHistoryBloc
    extends Bloc<ActivityHistoryEvent, ActivityHistoryState> {
  final GetActivityHistoriesUseCase _getActivityHistories;

  ActivityHistoryBloc({required GetActivityHistoriesUseCase getActivityHistories})
      : _getActivityHistories = getActivityHistories,
        super(ActivityHistoryInitial()) {
    on<FetchActivityHistory>(_onFetchActivityHistory);
  }

  Future<void> _onFetchActivityHistory(
    FetchActivityHistory event,
    Emitter<ActivityHistoryState> emit,
  ) async {
    emit(ActivityHistoryLoading());
    await _loadData(event.userId, emit);
  }

  Future<void> _loadData(
    String userId,
    Emitter<ActivityHistoryState> emit,
  ) async {
    try {
      final histories = await _getActivityHistories(userId: userId);

      if (histories.isEmpty) {
        emit(ActivityHistoryEmpty());
        return;
      }

      // Group histories by date (Today, Yesterday, DD/MM/YYYY)
      final Map<String, List<ActivityHistoryEntity>> grouped = {};
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));

      for (final item in histories) {
        final itemDate = DateTime(
          item.startedAt.year,
          item.startedAt.month,
          item.startedAt.day,
        );

        String groupHeader;
        if (itemDate == today) {
          groupHeader = 'Today';
        } else if (itemDate == yesterday) {
          groupHeader = 'Yesterday';
        } else {
          groupHeader = DateFormat('dd/MM/yyyy').format(item.startedAt);
        }

        if (!grouped.containsKey(groupHeader)) {
          grouped[groupHeader] = [];
        }
        grouped[groupHeader]!.add(item);
      }

      emit(ActivityHistoryLoaded(
        histories: histories,
        groupedHistories: grouped,
      ));
    } catch (e) {
      emit(ActivityHistoryError(message: e.toString()));
    }
  }
}
