import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/features/profile/domain/entities/activity_history_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class ActivityHistoryRepository {
  Future<Either<Failure,List<ActivityHistoryEntity>>> getActivityHistories({required String userId});
}
