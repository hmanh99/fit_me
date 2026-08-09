import 'package:personal_fitness_tracker/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getCurrentProfile({required String userId});

  Future<void> updateUsername({required ProfileEntity profile});
  Future<void> updateHeight({required ProfileEntity profile});
  Future<void> updateWeight({required ProfileEntity profile});
  Future<void> updateAvatar({required ProfileEntity profile});
  Future<void> updateProfile({
    required ProfileEntity profile,
    required bool updateUsername,
    required bool updateHeight,
    required bool updateWeight,
    required bool updateAvatar,
  });
  Future<void> logoutProfile();
}