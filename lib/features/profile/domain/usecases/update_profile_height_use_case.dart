import 'package:personal_fitness_tracker/features/profile/domain/entities/profile_entity.dart';
import 'package:personal_fitness_tracker/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileHeightUseCase {
  final ProfileRepository repository;

  const UpdateProfileHeightUseCase(this.repository);

  Future<void> call({required ProfileEntity profile}) {
    return repository.updateHeight(profile: profile);
  }
}
