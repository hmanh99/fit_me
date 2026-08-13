import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/workout/domain/entities/set_session_entity.dart';
import 'package:fit_me/features/workout/domain/repositories/workout_repository.dart';
import 'package:fpdart/fpdart.dart';

class CreateSetSessionUseCase implements UseCase<void, SetSessionParams>{
  final WorkoutRepository repository;

  const CreateSetSessionUseCase(this.repository);

  @override
  Future<Either<Failure,void>> call(SetSessionParams params) async {
    return repository.createSetSession(params.setSession);
  }
}

class SetSessionParams {
  final SetSessionEntity setSession;

  SetSessionParams({required this.setSession});
}
