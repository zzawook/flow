import 'package:flow_mobile/domain/redux/actions/notification_action.dart';
import 'package:flow_mobile/domain/redux/actions/user_actions.dart';
import 'package:flow_mobile/domain/redux/states/notification_state.dart';

NotificationState notificationReducer(NotificationState state, dynamic action) {
  if (action is DeleteUserAction || action is ClearNotificationStateAction) {
    return NotificationState.initial();
  }
  if (action is SetNotificationStateAction) {
    return action.notificationState;
  }
  return state;
}
