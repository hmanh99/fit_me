import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/workout/domain/entities/workout_session_entity.dart';
import 'package:fit_me/features/workout/domain/repositories/workout_repository.dart';
import 'package:fpdart/fpdart.dart';

class CreateWorkoutSessionUseCase implements UseCase<int, CreateWorkoutSessionParams>{
  final WorkoutRepository repository;

  const CreateWorkoutSessionUseCase(this.repository);

  @override
  Future<Either<Failure, int>> call(CreateWorkoutSessionParams params) {
    return repository.createWorkoutSession(params.workoutSession);
  }
}

class CreateWorkoutSessionParams {
  final WorkoutSessionEntity workoutSession;

  CreateWorkoutSessionParams({required this.workoutSession});
}
