import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/workout/domain/entities/workout_plan_entity.dart';
import 'package:fit_me/features/workout/domain/repositories/workout_repository.dart';
import 'package:fpdart/fpdart.dart';


class GetWorkoutPlansUseCase implements UseCase<List<WorkoutPlanEntity>, WorkoutPlansParams>{
  final WorkoutRepository repository;

  const GetWorkoutPlansUseCase(this.repository);

  @override
  Future<Either<Failure, List<WorkoutPlanEntity>>> call(WorkoutPlansParams params) {
    return repository.getWorkoutPlans(params.userId);
  }
}

class WorkoutPlansParams {
  final String? userId;

  WorkoutPlansParams({required this.userId});
}
