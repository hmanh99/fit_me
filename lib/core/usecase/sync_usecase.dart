import 'package:fit_me/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class SyncUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}