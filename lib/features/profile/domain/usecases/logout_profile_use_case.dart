import 'package:fit_me/features/profile/domain/repositories/profile_repository.dart';

class LogoutProfileUseCase {
  final ProfileRepository repository;

  const LogoutProfileUseCase(this.repository);

  Future<void> call() => repository.logoutProfile();
}
