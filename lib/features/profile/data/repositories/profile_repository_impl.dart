import 'package:fit_me/core/error/exceptions.dart';
import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:fit_me/features/profile/data/models/profile_model.dart';
import 'package:fit_me/features/profile/domain/entities/profile_entity.dart';
import 'package:fit_me/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class ProfileRepositoriesImpl implements ProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;

  const ProfileRepositoriesImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, ProfileEntity>> getCurrentProfile({
    required String userId,
  }) async {
    try {
      final response = await remoteDatasource.getCurrentProfile(userId: userId);
      return Right(response.toEntity());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logoutProfile() async {
    try {
      return Right(remoteDatasource.logoutProfile());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile({
    required ProfileEntity profile,
  }) async {
    try {
      return Right(
        await remoteDatasource.updateProfile(
          model: ProfileModel.fromEntity(profile),
        ),
      );
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadAvatar({
    required String userId,
    required String filePath,
  }) async {
    try {
      final url = await remoteDatasource.uploadAvatar(
        userId: userId,
        filePath: filePath,
      );
      return Right(url);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAvatar({
    required String userId,
    String? currentAvatarUrl,
  }) async {
    try {
      await remoteDatasource.deleteAvatar(
        userId: userId,
        currentAvatarUrl: currentAvatarUrl,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
