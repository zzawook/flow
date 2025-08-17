import 'package:flow_mobile/domain/entity/user.dart';

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

