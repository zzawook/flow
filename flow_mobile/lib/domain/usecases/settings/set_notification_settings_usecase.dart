import 'package:flow_mobile/domain/entities/notification_setting.dart';
import 'package:flow_mobile/domain/repositories/settings_repository.dart';

/// Use case for setting notification settings
abstract class SetNotificationSettingsUseCase {
  Future<void> execute(NotificationSetting notificationSetting);
}

/// Implementation of set notification settings use case
class SetNotificationSettingsUseCaseImpl implements SetNotificationSettingsUseCase {
  final SettingsRepository _settingsRepository;

  SetNotificationSettingsUseCaseImpl(this._settingsRepository);

  @override
  Future<void> execute(NotificationSetting notificationSetting) async {
    await _settingsRepository.setNotificationSetting(notificationSetting);
  }
}