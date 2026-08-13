import 'package:fit_me/core/usecase/sync_usecase.dart';
import 'package:fit_me/features/schedule/domain/entities/workout_schedule_entity.dart';
import 'package:fit_me/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';

class WatchSchedulesUseCase
    implements
        SyncUseCase<List<WorkoutScheduleEntity>, WatchSchedulesParams> {
  final ScheduleRepository repository;

  const WatchSchedulesUseCase(this.repository);

  @override
  Stream<Either<Failure, List<WorkoutScheduleEntity>>> call(
    WatchSchedulesParams params,
  ) {
    return repository.watchSchedules(userId: params.userId);
  }
}

class WatchSchedulesParams {
  final String userId;

  WatchSchedulesParams({required this.userId});
}
