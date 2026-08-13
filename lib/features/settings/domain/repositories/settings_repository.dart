import 'package:fit_me/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';
import '../entities/settings_entity.dart';

abstract class SettingsRepository {
  Future<Either<Failure, SettingsEntity>> getSettings();
  Future<Either<Failure,void>> saveLanguageCode(String code);
}
