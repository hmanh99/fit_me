import 'package:fit_me/features/schedule/domain/entities/workout_schedule_entity.dart';
import 'package:fit_me/features/schedule/domain/repositories/schedule_repository.dart';

class UpdateScheduleUseCase {
  final ScheduleRepository repository;

  const UpdateScheduleUseCase(this.repository);

  Future<void> call(WorkoutScheduleEntity schedule) {
    return repository.updateSchedule(schedule);
  }
}
