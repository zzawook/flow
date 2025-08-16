import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flow_mobile/domain/entities/notification_setting.dart';
import 'package:flow_mobile/domain/usecases/settings/set_notification_settings_usecase.dart';

import '../../../mocks/repository_mocks.dart';

void main() {
  late SetNotificationSettingsUseCaseImpl useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = SetNotificationSettingsUseCaseImpl(mockRepository);
  });

  group('SetNotificationSettingsUseCase', () {
    test('should call repository setNotificationSetting when execute is called', () async {
      // Arrange
      final notificationSetting = NotificationSetting(
        id: '1',
        type: NotificationType.transaction,
        isEnabled: true,
        title: 'Transaction Notifications',
        description: 'Get notified about transactions',
      );

      when(mockRepository.setNotificationSetting(any))
          .thenAnswer((_) async => {});

      // Act
      await useCase.execute(notificationSetting);

      // Assert
      verify(mockRepository.setNotificationSetting(notificationSetting)).called(1);
    });

    test('should throw exception when repository throws exception', () async {
      // Arrange
      final notificationSetting = NotificationSetting(
        id: '1',
        type: NotificationType.transaction,
        isEnabled: true,
        title: 'Transaction Notifications',
        description: 'Get notified about transactions',
      );

      when(mockRepository.setNotificationSetting(any))
          .thenThrow(Exception('Settings update failed'));

      // Act & Assert
      expect(
        () => useCase.execute(notificationSetting),
        throwsA(isA<Exception>()),
      );
    });
  });
}