import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/features/profile/domain/entities/profile_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getCurrentProfile({
    required String userId,
  });

  Future<Either<Failure, void>> updateProfile({required ProfileEntity profile});

  Future<Either<Failure, String>> uploadAvatar({
    required String userId,
    required String filePath,
  });

  Future<Either<Failure, void>> deleteAvatar({
    required String userId,
    String? currentAvatarUrl,
  });

  Future<Either<Failure, void>> logoutProfile();
}
