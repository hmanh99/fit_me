import 'package:fit_me/features/profile/data/datasource/activity_history_remote_datasource.dart';
import 'package:fit_me/features/profile/domain/entities/activity_history_entity.dart';
import 'package:fit_me/features/profile/domain/repositories/activity_history_repository.dart';

class ActivityHistoryRepositoryImpl implements ActivityHistoryRepository {
  final ActivityHistoryRemoteDatasource remoteDatasource;

  ActivityHistoryRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<ActivityHistoryEntity>> getActivityHistories({
    required String userId,
  }) async {
    try {
      return await remoteDatasource.getActitivyHistories(userId: userId);
    } catch (e) {
      rethrow;
    }
  }
}
