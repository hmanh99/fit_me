import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/profile/domain/entities/profile_entity.dart';
import 'package:fit_me/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';

class UpdateProfileParams {
  final ProfileEntity profile;

  const UpdateProfileParams({
    required this.profile,
  });
}

class UpdateProfileUseCase implements UseCase<void, UpdateProfileParams> {
  final ProfileRepository repository;

  const UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(
      profile: params.profile,
    );
  }
}
