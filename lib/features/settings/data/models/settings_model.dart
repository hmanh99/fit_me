import '../../domain/entities/settings_entity.dart';

class SettingsModel extends SettingsEntity {
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

  factory SettingsModel.fromEntity(SettingsEntity settings) {
    return SettingsModel(
      languageCode: settings.languageCode,
    );
  }

  SettingsEntity toEntity() {
    return SettingsEntity(
      languageCode: languageCode,
    );
  }
}
