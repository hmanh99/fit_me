import 'package:fit_me/features/schedule/domain/entities/workout_schedule_entity.dart';
import 'package:fit_me/features/schedule/domain/repositories/schedule_repository.dart';

class WatchSchedulesUseCase {
  final ScheduleRepository repository;

  const WatchSchedulesUseCase(this.repository);

  Stream<List<WorkoutScheduleEntity>> call(String userId) {
    return repository.watchSchedules(userId);
  }
}
