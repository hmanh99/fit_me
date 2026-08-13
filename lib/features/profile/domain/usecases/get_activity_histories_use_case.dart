import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/profile/domain/entities/activity_history_entity.dart';
import 'package:fit_me/features/profile/domain/repositories/activity_history_repository.dart';
import 'package:fpdart/fpdart.dart';


class GetActivityHistoriesUseCase
    implements UseCase<List<ActivityHistoryEntity>, ActiveHistoryParams> {
  final ActivityHistoryRepository repository;

  const GetActivityHistoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ActivityHistoryEntity>>> call(ActiveHistoryParams params) {
    return repository.getActivityHistories(userId: params.userId);
  }
}

class ActiveHistoryParams {
  final String userId;

  ActiveHistoryParams({required this.userId});
}
