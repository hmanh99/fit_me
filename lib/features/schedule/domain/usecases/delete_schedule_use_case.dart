import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteScheduleUseCase implements UseCase<void, DeleteScheduleParams> {
  final ScheduleRepository repository;

  const DeleteScheduleUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteScheduleParams params) {
    return repository.deleteSchedule(scheduleId: params.scheduleId);
  }
}

class DeleteScheduleParams {
  final int scheduleId;

  DeleteScheduleParams({required this.scheduleId});
}
