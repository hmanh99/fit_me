import 'package:personal_fitness_tracker/features/profile/domain/entities/profile_entity.dart';
import 'package:personal_fitness_tracker/features/profile/domain/repositories/profile_repository.dart';

class GetCurrentProfileUseCase {
  final ProfileRepository repository;

  const GetCurrentProfileUseCase(this.repository);

  Future<ProfileEntity> call({required String userId}) {
    return repository.getCurrentProfile(userId: userId);
  }
}
