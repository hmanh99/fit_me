import 'package:fit_me/features/profile/domain/entities/profile_entity.dart';
import 'package:fit_me/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileWeightUseCase {
  final ProfileRepository repository;

  const UpdateProfileWeightUseCase(this.repository);

  Future<void> call({required ProfileEntity profile}) {
    return repository.updateWeight(profile: profile);
  }
}
