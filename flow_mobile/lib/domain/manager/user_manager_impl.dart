import 'package:flow_mobile/domain/manager/user_manager.dart';
import 'package:flow_mobile/domain/entity/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserManagerImpl implements UserManager {
  final Box<User> _userBox;

  // Singleton instance
  static UserManagerImpl? _instance;

  // Private constructor to enforce singleton usage.
  UserManagerImpl._(this._userBox);

  // Asynchronous factory getter to return the singleton instance.
  static Future<UserManagerImpl> getInstance() async {
    if (_instance == null) {
      final box = await Hive.openBox<User>('userBox');
      _instance = UserManagerImpl._(box);
    }
    return _instance!;
  }

  @override
  Future<void> deleteUser() async {
    // Delete the user stored under the key 'user'
    await _userBox.delete('user');
  }

  @override
  Future<User> getUser() async {
    // Retrieve the user stored under the key 'user'
    final user = _userBox.get('user');
    if (user == null) {
      throw Exception("User not found");
    }
    return user;
  }

  @override
  Future<void> updateUser(User user) async {
    // Update (or add) the user stored under the key 'user'
    await _userBox.put('user', user);
  }
}
