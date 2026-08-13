import 'package:fit_me/core/error/exceptions.dart';
import 'package:fit_me/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:fit_me/features/auth/domain/entities/user_entities.dart';
import 'package:fit_me/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, UserEntity?>> currentUser() async {
    final user = remoteDatasource.currentUser;
    if (user == null) {
      return Left(Failure());
    }
    return Right(user.toEntity());
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await remoteDatasource.signUp(
        username: username,
        email: email,
        password: password,
      );
      return Right(response.toEntity());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await remoteDatasource.login(
        email: email,
        password: password,
      );
      return Right(response.toEntity());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      return Right(await remoteDatasource.logout());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({required String email}) async {
    try {
      return Right(await remoteDatasource.forgotPassword(email: email));
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, UserEntity?>>  watchAuthState() {
    return remoteDatasource.watchAuthState().map((user) {
      if(user == null){
        return Left(Failure());
      }
      return Right(user.toEntity());
    });
  }
}
