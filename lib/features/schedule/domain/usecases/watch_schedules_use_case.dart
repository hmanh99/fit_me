import 'package:personal_fitness_tracker/features/schedule/domain/entities/workout_schedule_entity.dart';
import 'package:personal_fitness_tracker/features/schedule/domain/repositories/schedule_repository.dart';

class WatchSchedulesUseCase {
  final ScheduleRepository repository;

  const WatchSchedulesUseCase(this.repository);

  Stream<List<WorkoutScheduleEntity>> call(String userId) {
    return repository.watchSchedules(userId);
  }
}
