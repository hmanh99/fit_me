import 'package:personal_fitness_tracker/core/services/auth_services.dart';
import 'package:personal_fitness_tracker/features/auth/domain/entities/user_entities.dart';
import 'package:personal_fitness_tracker/features/auth/domain/repositories/auth_repositories.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService = AuthService();

  @override
  Future<UserModel> signUp({required String username, required String email, required String password}) async {
    final user = await _authService.signUp(email: email, password: password, username: username);

    return UserModel(id: user.uid, email: email);
  }

  @override
  Future<UserModel> login({required String email, required String password}) async {
    final user = await _authService.signIn(email: email, password: password);
    return UserModel(id: user!.uid, email: email);
  }

  @override
  Future<void> logout() async {
    await _authService.signOut();
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await _authService.forgotPassword(email: email);
  }
}