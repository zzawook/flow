import 'package:flow_mobile/domain/repositories/settings_repository.dart';

/// Use case for getting display balance on home preference
abstract class GetDisplayBalanceUseCase {
  Future<bool> execute();
}

/// Implementation of get display balance use case
class GetDisplayBalanceUseCaseImpl implements GetDisplayBalanceUseCase {
  final SettingsRepository _settingsRepository;

  GetDisplayBalanceUseCaseImpl(this._settingsRepository);

  @override
  Future<bool> execute() async {
    return await _settingsRepository.getDisplayBalanceOnHome();
  }
}