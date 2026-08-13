import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/settings/domain/repositories/settings_repository.dart';
import 'package:fpdart/fpdart.dart';

class SaveLanguageCodeUseCase implements UseCase<void, LanguageCodeParams> {
  final SettingsRepository repository;

  const SaveLanguageCodeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(LanguageCodeParams params) =>
      repository.saveLanguageCode(params.code);
}

class LanguageCodeParams {
  final String code;

  LanguageCodeParams({required this.code});
}
