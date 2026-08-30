import 'package:fit_me/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class SyncUseCase<SuccessType, Params> {
  Stream<Either<Failure, SuccessType>> call(Params params);
}