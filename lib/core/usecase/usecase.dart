import 'package:fpdart/fpdart.dart';
import 'package:personal_fitness_tracker/core/error/failure.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}
