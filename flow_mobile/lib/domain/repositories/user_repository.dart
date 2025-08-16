import 'package:flow_mobile/domain/entities/user.dart';

/// Repository interface for user operations
/// Matches existing UserManager method signatures for compatibility
abstract class UserRepository {
  /// Get current user
  Future<User> getUser();
  
  /// Update user information
  Future<void> updateUser(User user);
  
  /// Delete user
  Future<void> deleteUser();
}