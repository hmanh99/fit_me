import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/schedule/domain/entities/workout_schedule_entity.dart';
import 'package:fit_me/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:fpdart/fpdart.dart';

class SchedulesByMonthParams {
  final String userId;
  final int year;
  final int month;

  const SchedulesByMonthParams({
    required this.userId,
    required this.year,
    required this.month,
  });
}

class GetSchedulesByMonthUseCase implements UseCase<List<WorkoutScheduleEntity>, SchedulesByMonthParams> {
  final ScheduleRepository repository;

  const GetSchedulesByMonthUseCase(this.repository);

  @override
  Future<Either<Failure, List<WorkoutScheduleEntity>>> call(SchedulesByMonthParams params) async {
    return repository.getSchedulesByMonth(
      userId: params.userId,
      year: params.year,
      month: params.month,
    );
  }
}
