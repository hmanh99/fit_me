import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/workout/domain/entities/workout_plan_entity.dart';
import 'package:fit_me/features/workout/domain/repositories/workout_repository.dart';
import 'package:fpdart/fpdart.dart';

class CreateWorkoutPlanUseCase implements UseCase<WorkoutPlanEntity, CreateWorkoutPlanParams> {
  final WorkoutRepository repository;

  const CreateWorkoutPlanUseCase(this.repository);

  @override
  Future<Either<Failure, WorkoutPlanEntity>> call(CreateWorkoutPlanParams params) {
    return repository.createWorkoutPlan(params.plan);
  }
}

class CreateWorkoutPlanParams {
  final WorkoutPlanEntity plan;

  const CreateWorkoutPlanParams({required this.plan});
}
