import 'package:fit_me/features/settings/domain/entities/app_settings.dart';
import 'package:fit_me/features/settings/domain/repositories/settings_repository.dart';

class GetSettingsUseCase {
  final SettingsRepository repository;

  const GetSettingsUseCase(this.repository);

  Future<AppSettings> call() => repository.getSettings();
}
