import 'package:fit_me/core/error/exceptions.dart';
import 'package:fit_me/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';
import '../models/settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, SettingsEntity>> getSettings() async {
    try {
      final languageCode = await localDataSource.getLanguageCode();

      final model = SettingsModel(
        languageCode: languageCode ?? 'en',
      );

      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveLanguageCode(String code) async {
    try {
      return Right(await localDataSource.saveLanguageCode(code));
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
