import '../../domain/entities/app_settings.dart';

class SettingsModel extends AppSettings {
  const SettingsModel({
    required super.languageCode,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
     final languageCode = json['languageCode'] as String? ?? 'en';

    return SettingsModel(
      languageCode: languageCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'languageCode': languageCode,
    };
  }

  factory SettingsModel.fromEntity(AppSettings settings) {
    return SettingsModel(
      languageCode: settings.languageCode,
    );
  }

  AppSettings toEntity() {
    return AppSettings(
      languageCode: languageCode,
    );
  }
}
