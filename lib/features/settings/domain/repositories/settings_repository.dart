import '../entities/app_settings.dart';

abstract class SettingsRepository {
  Future<AppSettings> getSettings();
  Future<void> saveThemeMode(AppThemeMode mode);
  Future<void> saveLanguageCode(String code);
}
