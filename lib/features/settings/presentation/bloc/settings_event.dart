import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class SettingsLoadRequested extends SettingsEvent {
  const SettingsLoadRequested();
}


class SettingsLanguageChanged extends SettingsEvent {
  final String languageCode;

  const SettingsLanguageChanged(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}
