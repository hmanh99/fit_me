import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';
import '../models/settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<AppSettings> getSettings() async {
    final languageCode = await localDataSource.getLanguageCode();

    final model = SettingsModel(
      languageCode: languageCode ?? 'en',
    );

    return model.toEntity();
  }

  @override
  Future<void> saveLanguageCode(String code) async {
    await localDataSource.saveLanguageCode(code);
  }
}
