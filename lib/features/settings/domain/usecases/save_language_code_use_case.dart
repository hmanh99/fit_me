import 'package:personal_fitness_tracker/features/settings/domain/repositories/settings_repository.dart';

class SaveLanguageCodeUseCase {
  final SettingsRepository repository;

  const SaveLanguageCodeUseCase(this.repository);

  Future<void> call(String code) => repository.saveLanguageCode(code);
}
