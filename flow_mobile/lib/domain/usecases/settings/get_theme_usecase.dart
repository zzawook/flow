import 'package:flow_mobile/domain/repositories/settings_repository.dart';

/// Use case for getting application theme
abstract class GetThemeUseCase {
  Future<String> execute();
}

/// Implementation of get theme use case
class GetThemeUseCaseImpl implements GetThemeUseCase {
  final SettingsRepository _settingsRepository;

  GetThemeUseCaseImpl(this._settingsRepository);

  @override
  Future<String> execute() async {
    return await _settingsRepository.getTheme();
  }
}