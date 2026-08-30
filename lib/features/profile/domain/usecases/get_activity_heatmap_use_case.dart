import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/profile/domain/repositories/activity_history_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetActivityHeatmapUseCase
    implements UseCase<Map<DateTime, int>, ActivityHeatmapParams> {
  final ActivityHistoryRepository repository;

  const GetActivityHeatmapUseCase(this.repository);

  @override
  Future<Either<Failure, Map<DateTime, int>>> call(
    ActivityHeatmapParams params,
  ) {
    return repository.getActivityHeatmap(
      userId: params.userId,
      days: params.days,
    );
  }
}

class ActivityHeatmapParams {
  final String userId;
  final int days;

  const ActivityHeatmapParams({
    required this.userId,
    this.days = 365,
  });
}
