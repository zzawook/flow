import 'package:flow_mobile/domain/redux/actions/user_actions.dart';
import 'package:flow_mobile/domain/redux/states/notification_state.dart';

NotificationState notificationReducer(NotificationState state, dynamic action) {
  if (action is DeleteUserAction) {
    return NotificationState.initial();
  }
  return state;
}
