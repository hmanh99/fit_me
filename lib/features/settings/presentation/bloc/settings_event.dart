import 'package:equatable/equatable.dart';
import '../../domain/entities/app_settings.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class SettingsLoadRequested extends SettingsEvent {
  const SettingsLoadRequested();
}

class SettingsThemeModeChanged extends SettingsEvent {
  final AppThemeMode mode;

  const SettingsThemeModeChanged(this.mode);

  @override
  List<Object?> get props => [mode];
}

class SettingsLanguageChanged extends SettingsEvent {
  final String languageCode;

  const SettingsLanguageChanged(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}
