import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fit_me/features/profile/domain/entities/activity_history_entity.dart';
import 'package:fit_me/features/profile/domain/usecases/get_activity_histories_use_case.dart';
import 'package:fit_me/features/profile/domain/usecases/get_activity_heatmap_use_case.dart';
import 'package:fit_me/features/profile/presentation/bloc/activity_history_event.dart';
import 'package:fit_me/features/profile/presentation/bloc/activity_history_state.dart';

class ActivityHistoryBloc
    extends Bloc<ActivityHistoryEvent, ActivityHistoryState> {
  final GetActivityHistoriesUseCase _getActivityHistories;
  final GetActivityHeatmapUseCase? _getActivityHeatmap;

  ActivityHistoryBloc({
    required GetActivityHistoriesUseCase getActivityHistories,
    GetActivityHeatmapUseCase? getActivityHeatmap,
  })  : _getActivityHistories = getActivityHistories,
        _getActivityHeatmap = getActivityHeatmap,
        super(ActivityHistoryInitial()) {
    on<FetchActivityHistory>(_onFetchActivityHistory);
    on<FetchActivityHeatmap>(_onFetchActivityHeatmap);
  }

  Future<void> _onFetchActivityHistory(
    FetchActivityHistory event,
    Emitter<ActivityHistoryState> emit,
  ) async {
    emit(ActivityHistoryLoading());
    await _loadData(event.userId, event.heatmapDays, emit);
  }

  Future<void> _onFetchActivityHeatmap(
    FetchActivityHeatmap event,
    Emitter<ActivityHistoryState> emit,
  ) async {
    if (state is ActivityHistoryLoaded) {
      final currentState = state as ActivityHistoryLoaded;
      if (_getActivityHeatmap != null) {
        final heatmapResult = await _getActivityHeatmap(
          ActivityHeatmapParams(userId: event.userId, days: event.days),
        );
        heatmapResult.fold(
          (failure) {}, // keep existing heatmap on error
          (counts) => emit(
            currentState.copyWith(
              heatmapCounts: counts,
              heatmapDays: event.days,
            ),
          ),
        );
      } else {
        // Compute from loaded histories
        final counts = _computeHeatmapFromHistories(
          currentState.histories,
          event.days,
        );
        emit(
          currentState.copyWith(
            heatmapCounts: counts,
            heatmapDays: event.days,
          ),
        );
      }
    }
  }

  Future<void> _loadData(
    String userId,
    int heatmapDays,
    Emitter<ActivityHistoryState> emit,
  ) async {
    try {
      final result = await _getActivityHistories(
        ActiveHistoryParams(userId: userId),
      );

      await result.fold(
        (failure) async {
          emit(ActivityHistoryError(message: failure.message));
        },
        (histories) async {
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
            final localStarted = item.startedAt.toLocal();
            final itemDate = DateTime(
              localStarted.year,
              localStarted.month,
              localStarted.day,
            );

            String groupHeader;
            if (itemDate == today) {
              groupHeader = 'Today';
            } else if (itemDate == yesterday) {
              groupHeader = 'Yesterday';
            } else {
              groupHeader = DateFormat('dd/MM/yyyy').format(localStarted);
            }

            if (!grouped.containsKey(groupHeader)) {
              grouped[groupHeader] = [];
            }
            grouped[groupHeader]!.add(item);
          }

          Map<DateTime, int> heatmapCounts = {};
          if (_getActivityHeatmap != null) {
            final heatmapResult = await _getActivityHeatmap(
              ActivityHeatmapParams(userId: userId, days: heatmapDays),
            );
            heatmapResult.fold(
              (_) => heatmapCounts = _computeHeatmapFromHistories(histories, heatmapDays),
              (counts) => heatmapCounts = counts,
            );
          } else {
            heatmapCounts = _computeHeatmapFromHistories(histories, heatmapDays);
          }

          emit(
            ActivityHistoryLoaded(
              histories: histories,
              groupedHistories: grouped,
              heatmapCounts: heatmapCounts,
              heatmapDays: heatmapDays,
            ),
          );
        },
      );
    } catch (e) {
      emit(ActivityHistoryError(message: e.toString()));
    }
  }

  Map<DateTime, int> _computeHeatmapFromHistories(
    List<ActivityHistoryEntity> histories,
    int days,
  ) {
    final Map<DateTime, int> counts = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final cutoffDate = DateTime(now.year, now.month, now.day - (days - 1));

    for (final item in histories) {
      final localDate = item.startedAt.toLocal();
      final dayKey = DateTime(localDate.year, localDate.month, localDate.day);
      if (!dayKey.isBefore(cutoffDate) && !dayKey.isAfter(today)) {
        counts[dayKey] = (counts[dayKey] ?? 0) + 1;
      }
    }
    return counts;
  }
}
