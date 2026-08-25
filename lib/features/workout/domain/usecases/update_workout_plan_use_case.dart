import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/workout/domain/entities/workout_plan_entity.dart';
import 'package:fit_me/features/workout/domain/repositories/workout_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateWorkoutPlanUseCase implements UseCase<WorkoutPlanEntity, UpdateWorkoutPlanParams> {
  final WorkoutRepository repository;

  const UpdateWorkoutPlanUseCase(this.repository);

  @override
  Future<Either<Failure, WorkoutPlanEntity>> call(UpdateWorkoutPlanParams params) {
    return repository.updateWorkoutPlan(params.plan);
  }
}

class UpdateWorkoutPlanParams {
  final WorkoutPlanEntity plan;

  const UpdateWorkoutPlanParams({required this.plan});
}
