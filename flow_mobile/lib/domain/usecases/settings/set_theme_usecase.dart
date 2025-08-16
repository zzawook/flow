import 'package:flow_mobile/domain/repositories/settings_repository.dart';

/// Use case for setting application theme
abstract class SetThemeUseCase {
  Future<void> execute(String theme);
}

/// Implementation of set theme use case
class SetThemeUseCaseImpl implements SetThemeUseCase {
  final SettingsRepository _settingsRepository;

  SetThemeUseCaseImpl(this._settingsRepository);

  @override
  Future<void> execute(String theme) async {
    await _settingsRepository.setTheme(theme);
  }
}