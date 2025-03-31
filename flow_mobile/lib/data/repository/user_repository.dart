import 'package:flow_mobile/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> getUser();
  Future<void> updateUser(User user);
  Future<void> deleteUser();
}