import 'package:flow_mobile/domain/repositories/settings_repository.dart';

/// Use case for getting font scale
abstract class GetFontScaleUseCase {
  Future<double> execute();
}

/// Implementation of get font scale use case
class GetFontScaleUseCaseImpl implements GetFontScaleUseCase {
  final SettingsRepository _settingsRepository;

  GetFontScaleUseCaseImpl(this._settingsRepository);

  @override
  Future<double> execute() async {
    return await _settingsRepository.getFontScale();
  }
}