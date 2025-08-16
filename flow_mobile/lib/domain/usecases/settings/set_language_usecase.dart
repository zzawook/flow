import 'package:flow_mobile/domain/repositories/settings_repository.dart';

/// Use case for setting application language
abstract class SetLanguageUseCase {
  Future<void> execute(String language);
}

/// Implementation of set language use case
class SetLanguageUseCaseImpl implements SetLanguageUseCase {
  final SettingsRepository _settingsRepository;

  SetLanguageUseCaseImpl(this._settingsRepository);

  @override
  Future<void> execute(String language) async {
    await _settingsRepository.setLanguage(language);
  }
}