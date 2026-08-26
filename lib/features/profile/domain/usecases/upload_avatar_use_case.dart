import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadAvatarParams {
  final String userId;
  final String filePath;

  const UploadAvatarParams({
    required this.userId,
    required this.filePath,
  });
}

class UploadAvatarUseCase implements UseCase<String, UploadAvatarParams> {
  final ProfileRepository repository;

  const UploadAvatarUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadAvatarParams params) async {
    return await repository.uploadAvatar(
      userId: params.userId,
      filePath: params.filePath,
    );
  }
}
