import 'package:flow_mobile/domain/entities/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Local data source interface for user operations
/// Abstracts Hive storage operations
abstract class UserLocalDataSource {
  /// Get current user from local storage
  Future<User> getUser();
  
  /// Update user in local storage
  Future<void> updateUser(User user);
  
  /// Delete user from local storage
  Future<void> deleteUser();
}

/// Implementation of UserLocalDataSource using Hive
class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Box<User> _userBox;

  UserLocalDataSourceImpl({required Box<User> userBox}) : _userBox = userBox;

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