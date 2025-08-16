import 'package:flow_mobile/domain/repositories/settings_repository.dart';

/// Use case for setting display balance on home preference
abstract class SetDisplayBalanceUseCase {
  Future<void> execute(bool displayBalance);
}

/// Implementation of set display balance use case
class SetDisplayBalanceUseCaseImpl implements SetDisplayBalanceUseCase {
  final SettingsRepository _settingsRepository;

  SetDisplayBalanceUseCaseImpl(this._settingsRepository);

  @override
  Future<void> execute(bool displayBalance) async {
    await _settingsRepository.setDisplayBalanceOnHome(displayBalance);
  }
}