import 'package:fit_me/features/schedule/domain/repositories/schedule_repository.dart';

class DeleteScheduleUseCase {
  final ScheduleRepository repository;

  const DeleteScheduleUseCase(this.repository);

  Future<void> call(int scheduleId) {
    return repository.deleteSchedule(scheduleId);
  }
}
