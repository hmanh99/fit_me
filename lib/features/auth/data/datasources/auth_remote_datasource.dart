import 'package:easy_localization/easy_localization.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/services/auth_services.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> signUp({
    required String username,
    required String email,
    required String password,
  });

  Future<UserModel> login({required String email, required String password});

  Future<void> logout();

  Future<void> forgotPassword({required String email});

  UserModel? get currentUser;

  Stream<UserModel?> watchAuthState();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDatasource{
  final AuthServices _authService;

  AuthRemoteDataSourceImpl(this._authService);

  @override
  // TODO: implement currentUser
  UserModel? get currentUser {
    final user = _authService.user;
    if (user == null) return null;
    return UserModel.fromJson(user);
  }

  @override
  Future<UserModel> signUp({required String username, required String email, required String password}) async {
    try {
      final user = await _authService.signUp(
        email: email,
        password: password,
        username: username,
      );
      return UserModel.fromJson(user, username: username);
    } on CustomAuthException {
      rethrow;
    } catch (e) {
      throw CustomAuthException(message: 'someting_went_wrong'.tr());
    }
  }

  @override
  Future<UserModel> login({required String email, required String password}) async {
    try {
      final user = await _authService.signIn(email: email, password: password);
      return UserModel.fromJson(user);
    } on CustomAuthException {
      rethrow;
    } catch (e) {
      throw CustomAuthException(message: 'someting_went_wrong'.tr());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _authService.signOut();
    } on CustomAuthException {
      rethrow;
    } catch (e) {
      throw CustomAuthException(message: 'someting_went_wrong'.tr());
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await _authService.forgotPassword(email: email);
    } on CustomAuthException {
      rethrow;
    } catch (e) {
      throw CustomAuthException(message: 'someting_went_wrong'.tr());
    }
  }

  @override
  Stream<UserModel?> watchAuthState() {
    return _authService.authStateChanges.map((user) {
      if (user == null) return null;
      return UserModel.fromJson(user);
    });
  }
}