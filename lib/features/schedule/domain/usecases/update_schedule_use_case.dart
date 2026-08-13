import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/schedule/domain/entities/workout_schedule_entity.dart';
import 'package:fit_me/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateScheduleParams {
  final WorkoutScheduleEntity schedule;

  const UpdateScheduleParams({required this.schedule});
}

class UpdateScheduleUseCase implements UseCase<void, UpdateScheduleParams> {
  final ScheduleRepository repository;

  const UpdateScheduleUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateScheduleParams params) {
    return repository.updateSchedule(schedule: params.schedule);
  }
}

