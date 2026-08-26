import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteAvatarParams {
  final String userId;
  final String? currentAvatarUrl;

  const DeleteAvatarParams({
    required this.userId,
    this.currentAvatarUrl,
  });
}

class DeleteAvatarUseCase implements UseCase<void, DeleteAvatarParams> {
  final ProfileRepository repository;

  const DeleteAvatarUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteAvatarParams params) async {
    return await repository.deleteAvatar(
      userId: params.userId,
      currentAvatarUrl: params.currentAvatarUrl,
    );
  }
}
