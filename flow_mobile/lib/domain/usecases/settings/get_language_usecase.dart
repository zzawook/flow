import 'package:flow_mobile/domain/repositories/settings_repository.dart';

/// Use case for getting application language
abstract class GetLanguageUseCase {
  Future<String> execute();
}

/// Implementation of get language use case
class GetLanguageUseCaseImpl implements GetLanguageUseCase {
  final SettingsRepository _settingsRepository;

  GetLanguageUseCaseImpl(this._settingsRepository);

  @override
  Future<String> execute() async {
    return await _settingsRepository.getLanguage();
  }
}