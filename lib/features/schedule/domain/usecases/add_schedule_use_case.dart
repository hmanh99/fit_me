import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/schedule/domain/entities/workout_schedule_entity.dart';
import 'package:fit_me/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:fpdart/fpdart.dart';

class AddScheduleUseCase implements UseCase<void, AddScheduleParams> {
  final ScheduleRepository repository;

  const AddScheduleUseCase(this.repository);

  @override
  Future<Either<Failure,void>> call(AddScheduleParams params) {
    return repository.addSchedule(schedule: params.schedule);
  }
}

class AddScheduleParams {
  final WorkoutScheduleEntity schedule;

  AddScheduleParams({required this.schedule});
}
