import 'package:equatable/equatable.dart';


class SettingsEntity extends Equatable {
  final String languageCode;

  const SettingsEntity({
    required this.languageCode,
  });

  SettingsEntity copyWith({
    String? languageCode,
  }) {
    return SettingsEntity(
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object?> get props => [languageCode];
}
