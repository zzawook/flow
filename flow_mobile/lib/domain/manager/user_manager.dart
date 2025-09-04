import 'package:flow_mobile/domain/entity/user.dart';

abstract class UserManager {
  Future<User?> getUser();
  Future<void> updateUser(User user);
  Future<void> deleteUser();

  Future<void> fetchUserFromRemote() async {}
}