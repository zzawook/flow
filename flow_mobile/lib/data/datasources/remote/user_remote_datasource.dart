import 'package:flow_mobile/domain/entities/user.dart';

/// Remote data source interface for user operations
/// Abstracts HTTP API operations
abstract class UserRemoteDataSource {
  /// Get user profile from remote server
  Future<User> getUserProfile();
  
  /// Update user profile on remote server
  Future<User> updateUserProfile(User user);
  
  /// Delete user account from remote server
  Future<void> deleteUserAccount();
  
  /// Sync user data with remote server
  Future<User> syncUserData();
}

/// Implementation of UserRemoteDataSource using HTTP API
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  // Note: This is a placeholder implementation
  // In a real app, this would use HTTP client to communicate with backend
  
  @override
  Future<User> getUserProfile() async {
    // Placeholder: In real implementation, this would fetch from backend
    throw UnimplementedError('Remote user operations not implemented');
  }
  
  @override
  Future<User> updateUserProfile(User user) async {
    // Placeholder: In real implementation, this would update on backend
    return user;
  }
  
  @override
  Future<void> deleteUserAccount() async {
    // Placeholder: In real implementation, this would delete from backend
  }
  
  @override
  Future<User> syncUserData() async {
    // Placeholder: In real implementation, this would sync with backend
    throw UnimplementedError('Remote user operations not implemented');
  }
}