import 'package:fit_me/features/schedule/domain/entities/workout_schedule_entity.dart';
import 'package:fit_me/features/schedule/domain/repositories/schedule_repository.dart';

class AddScheduleUseCase {
  final ScheduleRepository repository;

  const AddScheduleUseCase(this.repository);

  Future<void> call(WorkoutScheduleEntity schedule) {
    return repository.addSchedule(schedule);
  }
}
