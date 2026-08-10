import 'package:fit_me/features/profile/domain/entities/profile_entity.dart';
import 'package:fit_me/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileUseCaseParams {
  final ProfileEntity profile;
  final bool updateUsername;
  final bool updateHeight;
  final bool updateWeight;
  final bool updateAvatar;

  const UpdateProfileUseCaseParams({
    required this.profile,
    required this.updateUsername,
    required this.updateHeight,
    required this.updateWeight,
    required this.updateAvatar,
  });
}

class UpdateProfileUseCase {
  final ProfileRepository repository;

  const UpdateProfileUseCase(this.repository);

  Future<void> call(UpdateProfileUseCaseParams params) {
    return repository.updateProfile(
      profile: params.profile,
      updateUsername: params.updateUsername,
      updateHeight: params.updateHeight,
      updateWeight: params.updateWeight,
      updateAvatar: params.updateAvatar,
    );
  }
}
