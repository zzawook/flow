import 'package:flow_mobile/domain/repositories/settings_repository.dart';

/// Use case for setting font scale
abstract class SetFontScaleUseCase {
  Future<void> execute(double fontScale);
}

/// Implementation of set font scale use case
class SetFontScaleUseCaseImpl implements SetFontScaleUseCase {
  final SettingsRepository _settingsRepository;

  SetFontScaleUseCaseImpl(this._settingsRepository);

  @override
  Future<void> execute(double fontScale) async {
    await _settingsRepository.setFontScale(fontScale);
  }
}