import 'package:personal_fitness_tracker/features/schedule/domain/entities/workout_schedule_entity.dart';
import 'package:personal_fitness_tracker/features/schedule/domain/repositories/schedule_repository.dart';

class GetSchedulesByMonthParams {
  final String userId;
  final int year;
  final int month;

  const GetSchedulesByMonthParams({
    required this.userId,
    required this.year,
    required this.month,
  });
}

class GetSchedulesByMonthUseCase {
  final ScheduleRepository repository;

  const GetSchedulesByMonthUseCase(this.repository);

  Future<List<WorkoutScheduleEntity>> call(GetSchedulesByMonthParams params) {
    return repository.getSchedulesByMonth(
      userId: params.userId,
      year: params.year,
      month: params.month,
    );
  }
}
