import 'package:equatable/equatable.dart';

enum AppThemeMode {
  light,
  dark,
  system,
}

class AppSettings extends Equatable {
  final AppThemeMode themeMode;
  final String languageCode;

  const AppSettings({
    required this.themeMode,
    required this.languageCode,
  });

  AppSettings copyWith({
    AppThemeMode? themeMode,
    String? languageCode,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object?> get props => [themeMode, languageCode];
}
