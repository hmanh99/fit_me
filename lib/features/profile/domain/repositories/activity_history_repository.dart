import 'package:personal_fitness_tracker/features/profile/domain/entities/activity_history_entity.dart';

abstract class ActivityHistoryRepository {
  Future<List<ActivityHistoryEntity>> getActivityHistories({required String userId});
}
