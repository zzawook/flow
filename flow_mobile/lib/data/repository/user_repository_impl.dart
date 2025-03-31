import 'package:flow_mobile/data/repository/user_repository.dart';
import 'package:flow_mobile/domain/entities/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserRepositoryImpl implements UserRepository {
  final Box<User> _userBox;

  // Singleton instance
  static UserRepositoryImpl? _instance;

  // Private constructor to enforce singleton usage.
  UserRepositoryImpl._(this._userBox);

  // Asynchronous factory getter to return the singleton instance.
  static Future<UserRepositoryImpl> getInstance() async {
    if (_instance == null) {
      final box = await Hive.openBox<User>('userBox');
      _instance = UserRepositoryImpl._(box);
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
