import 'package:personal_fitness_tracker/features/profile/domain/entities/activity_history_entity.dart';
import 'package:personal_fitness_tracker/features/profile/domain/repositories/activity_history_repository.dart';

class GetActivityHistoriesUseCase {
  final ActivityHistoryRepository repository;

  const GetActivityHistoriesUseCase(this.repository);

  Future<List<ActivityHistoryEntity>> call({required String userId}) {
    return repository.getActivityHistories(userId: userId);
  }
}
