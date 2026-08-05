import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<int?> getThemeModeIndex();
  Future<void> saveThemeModeIndex(int index);
  Future<String?> getLanguageCode();
  Future<void> saveLanguageCode(String code);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String themeModeKey = 'CACHED_THEME_MODE_INDEX';
  static const String languageCodeKey = 'CACHED_LANGUAGE_CODE';

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<int?> getThemeModeIndex() async {
    return sharedPreferences.getInt(themeModeKey);
  }

  @override
  Future<void> saveThemeModeIndex(int index) async {
    await sharedPreferences.setInt(themeModeKey, index);
  }

  @override
  Future<String?> getLanguageCode() async {
    return sharedPreferences.getString(languageCodeKey);
  }

  @override
  Future<void> saveLanguageCode(String code) async {
    await sharedPreferences.setString(languageCodeKey, code);
  }
}
