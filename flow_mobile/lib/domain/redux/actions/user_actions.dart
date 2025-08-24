import 'package:flow_mobile/domain/entity/user.dart';
import 'package:flow_mobile/domain/redux/states/user_state.dart';

class UpdateUserAction {
  final User user;

  UpdateUserAction(this.user);
}

class UpdateUserNicknameAction {
  final String nickname;

  UpdateUserNicknameAction(this.nickname);
}

class DeleteUserAction {
  DeleteUserAction();
}

class SetUserStateAction {
  UserState userState;

  SetUserStateAction({required this.userState});
}

class ClearUserStateAction {}