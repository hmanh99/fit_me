import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_fitness_tracker/features/settings/domain/usecases/get_settings_use_case.dart';
import 'package:personal_fitness_tracker/features/settings/domain/usecases/save_language_code_use_case.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettingsUseCase _getSettings;
  final SaveLanguageCodeUseCase _saveLanguageCode;

  SettingsBloc({
    required GetSettingsUseCase getSettings,
    required SaveLanguageCodeUseCase saveLanguageCode,
  })  : _getSettings = getSettings,
        _saveLanguageCode = saveLanguageCode,
        super(SettingsState.initial()) {
    on<SettingsLoadRequested>(_onLoadRequested);
    on<SettingsLanguageChanged>(_onLanguageChanged);
  }

  Future<void> _onLoadRequested(
    SettingsLoadRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final settings = await _getSettings();
    emit(state.copyWith(settings: settings, isLoading: false));
  }

  Future<void> _onLanguageChanged(
    SettingsLanguageChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final updatedSettings =
        state.settings.copyWith(languageCode: event.languageCode);
    emit(state.copyWith(settings: updatedSettings));
    await _saveLanguageCode(event.languageCode);
  }
}
