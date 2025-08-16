import 'package:flow_mobile/domain/entities/notification_setting.dart';
import 'package:flow_mobile/domain/repositories/settings_repository.dart';

/// Use case for getting notification settings
abstract class GetNotificationSettingsUseCase {
  Future<NotificationSetting> execute();
}

/// Implementation of get notification settings use case
class GetNotificationSettingsUseCaseImpl implements GetNotificationSettingsUseCase {
  final SettingsRepository _settingsRepository;

  GetNotificationSettingsUseCaseImpl(this._settingsRepository);

  @override
  Future<NotificationSetting> execute() async {
    return await _settingsRepository.getNotificationSetting();
  }
}