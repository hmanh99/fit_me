import 'package:personal_fitness_tracker/features/profile/domain/entities/profile_entity.dart';
import 'package:personal_fitness_tracker/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileAvatarUseCase {
  final ProfileRepository repository;

  const UpdateProfileAvatarUseCase(this.repository);

  Future<void> call({required ProfileEntity profile}) {
    return repository.updateAvatar(profile: profile);
  }
}
