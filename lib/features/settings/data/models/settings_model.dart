import '../../domain/entities/app_settings.dart';

class SettingsModel extends AppSettings {
  const SettingsModel({
    required super.themeMode,
    required super.languageCode,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    final themeIndex = json['themeMode'] as int? ?? AppThemeMode.system.index;
    final themeMode = AppThemeMode.values.elementAtOrNull(themeIndex) ?? AppThemeMode.system;
    final languageCode = json['languageCode'] as String? ?? 'en';

    return SettingsModel(
      themeMode: themeMode,
      languageCode: languageCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.index,
      'languageCode': languageCode,
    };
  }

  factory SettingsModel.fromEntity(AppSettings settings) {
    return SettingsModel(
      themeMode: settings.themeMode,
      languageCode: settings.languageCode,
    );
  }

  AppSettings toEntity() {
    return AppSettings(
      themeMode: themeMode,
      languageCode: languageCode,
    );
  }
}
