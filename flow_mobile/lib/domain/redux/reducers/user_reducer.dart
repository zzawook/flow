import 'package:flow_mobile/domain/redux/states/user_state.dart';

UserState userReducer(UserState state, dynamic action) {
  if (action is UpdateUserAction) {
    return UserState(username: action.username, email: action.email);
  }
  return state;
}