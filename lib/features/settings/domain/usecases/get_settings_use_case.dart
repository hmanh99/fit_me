import 'package:personal_fitness_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:personal_fitness_tracker/features/settings/domain/repositories/settings_repository.dart';

class GetSettingsUseCase {
  final SettingsRepository repository;

  const GetSettingsUseCase(this.repository);

  Future<AppSettings> call() => repository.getSettings();
}
