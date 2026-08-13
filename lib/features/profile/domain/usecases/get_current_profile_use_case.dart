import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/profile/domain/entities/profile_entity.dart';
import 'package:fit_me/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetCurrentProfileUseCase
    implements UseCase<ProfileEntity, ProfileParams> {
  final ProfileRepository repository;

  const GetCurrentProfileUseCase(this.repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(ProfileParams params) {
    return repository.getCurrentProfile(userId: params.userId);
  }
}

class ProfileParams {
  final String userId;

  ProfileParams({required this.userId});
}
