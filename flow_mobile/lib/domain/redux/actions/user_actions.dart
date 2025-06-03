import 'package:flow_mobile/domain/entities/user.dart';

class UpdateUserAction {
  final User user;

  UpdateUserAction(this.user);
}

class UpdateUserNicknameAction {
  final String nickname;

  UpdateUserNicknameAction(this.nickname);
}
