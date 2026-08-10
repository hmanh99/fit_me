import 'package:fit_me/features/profile/domain/entities/profile_entity.dart';
import 'package:fit_me/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileUsernameUseCase {
  final ProfileRepository repository;

  const UpdateProfileUsernameUseCase(this.repository);

  Future<void> call({required ProfileEntity profile}) {
    return repository.updateUsername(profile: profile);
  }
}
