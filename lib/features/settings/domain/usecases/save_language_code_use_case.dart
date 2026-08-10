import 'package:fit_me/features/settings/domain/repositories/settings_repository.dart';

class SaveLanguageCodeUseCase {
  final SettingsRepository repository;

  const SaveLanguageCodeUseCase(this.repository);

  Future<void> call(String code) => repository.saveLanguageCode(code);
}
