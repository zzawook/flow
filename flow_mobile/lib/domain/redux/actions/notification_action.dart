import 'package:flow_mobile/domain/redux/states/notification_state.dart';

class SetNotificationStateAction {
  final NotificationState notificationState;

  SetNotificationStateAction({required this.notificationState});
}

class ClearNotificationStateAction {}