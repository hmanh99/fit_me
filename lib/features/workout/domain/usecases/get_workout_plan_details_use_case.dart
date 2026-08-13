import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/workout/domain/entities/workout_plan_entity.dart';
import 'package:fit_me/features/workout/domain/repositories/workout_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetWorkoutPlanDetailsUseCase implements UseCase<WorkoutPlanEntity, WorkoutPlanDetailParams>{
  final WorkoutRepository repository;

  const GetWorkoutPlanDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, WorkoutPlanEntity>> call(WorkoutPlanDetailParams params) {
    return repository.getWorkoutPlanDetails(params.planId);
  }
}

class WorkoutPlanDetailParams {
  final int planId;

  WorkoutPlanDetailParams({required this.planId});

}
