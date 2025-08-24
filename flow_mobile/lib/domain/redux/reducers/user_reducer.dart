import 'package:flow_mobile/domain/redux/actions/auth_action.dart';
import 'package:flow_mobile/domain/redux/actions/user_actions.dart';
import 'package:flow_mobile/domain/redux/states/user_state.dart';

UserState userReducer(UserState state, dynamic action) {
  if (action is UpdateUserAction) {
    return UserState(
      user: action.user,
    );
  }
  if (action is SetUserStateAction) {
    return action.userState;
  }
  if (action is UpdateUserNicknameAction) {
    return UserState(user: state.user?.copyWith(nickname: action.nickname));
  }
  if (action is DeleteUserAction) {
    return UserState(user: null);
  }
  if (action is SignupSuccessAction) {
    return UserState(
      user: state.user?.copyWith(
        nickname: action.name,
        email: action.email,
      ),
    );
  }
  return state;
}