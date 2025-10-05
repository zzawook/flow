import 'package:flow_mobile/domain/entity/user.dart';

/// Test data for user profile
/// Provides mock user for testing without backend dependency
class UserTestData {
  /// Get test user profile
  /// Email: kjaehyeok21@gmail.com
  /// Date of Birth: January 25, 2002
  static User getTestUser() {
    return User(
      name: 'Test User',
      email: 'kjaehyeok21@gmail.com',
      dateOfBirth: DateTime(2002, 1, 25),
      phoneNumber: '+65 9123 4567',
      nickname: 'TestUser',
    );
  }
}

