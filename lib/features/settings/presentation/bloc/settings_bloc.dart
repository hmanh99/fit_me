import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/settings_repository.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository repository;

  SettingsBloc({required this.repository}) : super(SettingsState.initial()) {
    on<SettingsLoadRequested>(_onLoadRequested);
    on<SettingsThemeModeChanged>(_onThemeModeChanged);
    on<SettingsLanguageChanged>(_onLanguageChanged);
  }

  Future<void> _onLoadRequested(
    SettingsLoadRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final settings = await repository.getSettings();
    emit(state.copyWith(settings: settings, isLoading: false));
  }

  Future<void> _onThemeModeChanged(
    SettingsThemeModeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final updatedSettings = state.settings.copyWith(themeMode: event.mode);
    emit(state.copyWith(settings: updatedSettings));
    await repository.saveThemeMode(event.mode);
  }

  Future<void> _onLanguageChanged(
    SettingsLanguageChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final updatedSettings = state.settings.copyWith(languageCode: event.languageCode);
    emit(state.copyWith(settings: updatedSettings));
    await repository.saveLanguageCode(event.languageCode);
  }
}
