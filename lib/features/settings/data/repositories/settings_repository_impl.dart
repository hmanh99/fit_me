import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';
import '../models/settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<AppSettings> getSettings() async {
    final themeIndex = await localDataSource.getThemeModeIndex();
    final languageCode = await localDataSource.getLanguageCode();

    final themeMode = themeIndex != null && themeIndex >= 0 && themeIndex < AppThemeMode.values.length
        ? AppThemeMode.values[themeIndex]
        : AppThemeMode.system;

    final model = SettingsModel(
      themeMode: themeMode,
      languageCode: languageCode ?? 'en',
    );

    return model.toEntity();
  }

  @override
  Future<void> saveThemeMode(AppThemeMode mode) async {
    await localDataSource.saveThemeModeIndex(mode.index);
  }

  @override
  Future<void> saveLanguageCode(String code) async {
    await localDataSource.saveLanguageCode(code);
  }
}
