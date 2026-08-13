import 'package:fit_me/core/error/exceptions.dart';
import 'package:fit_me/features/profile/data/datasource/activity_history_remote_datasource.dart';
import 'package:fit_me/features/profile/domain/entities/activity_history_entity.dart';
import 'package:fit_me/features/profile/domain/repositories/activity_history_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';

class ActivityHistoryRepositoryImpl implements ActivityHistoryRepository {
  final ActivityHistoryRemoteDatasource remoteDatasource;

  ActivityHistoryRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<ActivityHistoryEntity>>> getActivityHistories({
    required String userId,
  }) async {
    try {
      final response = await remoteDatasource.getActitivyHistories(
        userId: userId,
      );
      return Right(response.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
