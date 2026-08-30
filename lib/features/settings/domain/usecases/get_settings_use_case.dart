import 'package:fit_me/core/error/failure.dart';
import 'package:fit_me/core/usecase/usecase.dart';
import 'package:fit_me/features/settings/domain/entities/settings_entity.dart';
import 'package:fit_me/features/settings/domain/repositories/settings_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetSettingsUseCase implements UseCase<SettingsEntity, NoParams>{
  final SettingsRepository repository;

  const GetSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, SettingsEntity>> call(NoParams params) => repository.getSettings();
}
