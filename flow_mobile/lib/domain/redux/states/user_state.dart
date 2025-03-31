import 'package:flow_mobile/domain/entities/user.dart';

class UserState {
  final User user;

  UserState({required this.user});

  factory UserState.initial() => UserState(user: User.initial());
}
