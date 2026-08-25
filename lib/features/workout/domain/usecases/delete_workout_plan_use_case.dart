import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/workout/domain/repositories/workout_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteWorkoutPlanUseCase implements UseCase<void, DeleteWorkoutPlanParams> {
  final WorkoutRepository repository;

  const DeleteWorkoutPlanUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteWorkoutPlanParams params) {
    return repository.deleteWorkoutPlan(params.planId);
  }
}

class DeleteWorkoutPlanParams {
  final int planId;

  const DeleteWorkoutPlanParams({required this.planId});
}
