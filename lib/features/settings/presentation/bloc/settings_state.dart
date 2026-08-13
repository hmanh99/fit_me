import 'package:equatable/equatable.dart';
import '../../domain/entities/settings_entity.dart';

class SettingsState extends Equatable {
  final SettingsEntity settings;
  final bool isLoading;

  const SettingsState({
    required this.settings,
    this.isLoading = false,
  });

  factory SettingsState.initial() {
    return const SettingsState(
      settings: SettingsEntity(
        languageCode: 'en',
      ),
      isLoading: true,
    );
  }

  SettingsState copyWith({
    SettingsEntity? settings,
    bool? isLoading,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [settings, isLoading];
}
