import 'package:personal_fitness_tracker/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:personal_fitness_tracker/features/profile/data/models/profile_model.dart';
import 'package:personal_fitness_tracker/features/profile/domain/entities/profile_entity.dart';
import 'package:personal_fitness_tracker/features/profile/domain/repositories/profile_repositories.dart';

class ProfileRepositoriesImpl implements ProfileRepositories {
  final ProfileRemoteDatasource remoteDatasource;

  const ProfileRepositoriesImpl({required this.remoteDatasource});

  @override
  Future<ProfileEntity> getCurrentProfile({required String userId}) async {
    try {
      return await remoteDatasource.getCurrentProfile(userId: userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateAvatar({required ProfileEntity profile}) async {
    try {
      final model = ProfileModel.fromEntity(profile);
      await remoteDatasource.updateAvatar(model: model);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateHeight({required ProfileEntity profile}) async {
    try {
      final model = ProfileModel.fromEntity(profile);
      await remoteDatasource.updateHeight(model: model);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUsername({required ProfileEntity profile}) async {
    try {
      final model = ProfileModel.fromEntity(profile);
      await remoteDatasource.updateUsername(model: model);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateWeight({required ProfileEntity profile}) async {
    try {
      final model = ProfileModel.fromEntity(profile);
      await remoteDatasource.updateWeight(model: model);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateProfile({
    required ProfileEntity profile,
    required bool updateUsername,
    required bool updateHeight,
    required bool updateWeight,
    required bool updateAvatar,
  }) async {
    try {
      final model = ProfileModel.fromEntity(profile);
      await remoteDatasource.updateProfile(
        model: model,
        updateUsername: updateUsername,
        updateHeight: updateHeight,
        updateWeight: updateWeight,
        updateAvatar: updateAvatar,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logoutProfile() async {
    // TODO: implement logoutProfile
    try {
      await remoteDatasource.logoutProfile();
    } catch (e) {
      rethrow;
    }
  }
}
