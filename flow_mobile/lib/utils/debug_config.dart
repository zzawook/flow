/// Debug configuration for testing various UI states without backend dependency
///
/// Usage:
/// 1. Set `isDebugMode = true` to enable debug features
/// 2. Configure test modes for different features:
///    - authTestMode: Skip login/signup flow
///    - transactionHistoryTestMode: Load test transactions
///    - userProfileTestMode: Use test user profile
///    - recurringSpendingMode: Test recurring spending UI
///    - cardTestMode: Test card UI
///    - monthlyAssetTestMode: Test monthly asset chart
/// 3. Hot reload the app
/// 4. Login with email: kjaehyeok21@gmail.com (any password in test mode)
///
/// IMPORTANT: Set `isDebugMode = false` before production builds!
///
/// See: docs/DEBUG_MODE_TEST_AUTHENTICATION.md for detailed documentation
library;

enum RecurringSpendingTestMode {
  /// Use real API data (production behavior)
  production,

  /// Show loading state indefinitely
  /// Tests: Loading UI, spinner positioning
  loading,

  /// Show error state with test error message
  /// Tests: Error UI, error message formatting
  error,

  /// Show empty state (no recurring spendings)
  /// Tests: Empty state UI, messaging
  empty,

  /// Show a single recurring spending item
  /// Tests: Basic rendering, single item padding
  singleItem,

  /// Show multiple diverse recurring spending items (6 items)
  /// Tests: Scrolling, category variety, amount formatting
  multipleItems,

  /// Show edge cases: long names, various intervals, extreme amounts
  /// Tests: Text truncation, interval labels, boundary conditions
  edgeCases,
}

enum CardTestMode { none, multipleItems, singleItem, edgeCases, empty }

enum MonthlyAssetTestMode {
  /// Use real API data (production behavior)
  production,

  /// Show loading state indefinitely
  /// Tests: Loading UI, skeleton/spinner in chart
  loading,

  /// Show error state with test error message
  /// Tests: Error UI, error message display
  error,

  /// Show empty state (no asset data)
  /// Tests: Empty state UI, "No data" messaging
  empty,

  /// Show normal 6-month asset data
  /// Tests: Basic chart rendering, bar heights, labels
  multipleItems,

  /// Show edge cases: zero values, negative values, huge amounts
  /// Tests: Chart boundary conditions, label formatting
  edgeCases,
}

enum AuthTestMode {
  /// Use real API authentication
  production,

  /// Skip authentication and login directly with test account
  /// Email: kjaehyeok21@gmail.com
  /// Tests: Bypass login/signup flow, skip email verification
  testAccount,
}

enum TransactionHistoryTestMode {
  /// Use real API data (production behavior)
  production,

  /// Show a single transaction per month for the last 6 months
  /// Tests: Basic transaction rendering, minimal data
  singleItemPerMonth,

  /// Show multiple diverse transactions (~50 per month for 6 months)
  /// Tests: Full transaction flow with realistic data volume
  multipleItems,
}

enum UserProfileTestMode {
  /// Use real API data (production behavior)
  production,

  /// Use test user profile
  /// Email: kjaehyeok21@gmail.com, DOB: Jan 25, 2002
  /// Tests: User profile display, age calculations
  testUser,
}

class DebugConfig {
  static const bool isDebugMode = true;

  static const RecurringSpendingTestMode recurringSpendingMode =
      RecurringSpendingTestMode.multipleItems;

  static const CardTestMode cardTestMode = CardTestMode.multipleItems;

  static const MonthlyAssetTestMode monthlyAssetTestMode =
      MonthlyAssetTestMode.multipleItems;

  static const AuthTestMode authTestMode = AuthTestMode.testAccount;

  static const TransactionHistoryTestMode transactionHistoryTestMode =
      TransactionHistoryTestMode.multipleItems;

  static const UserProfileTestMode userProfileTestMode =
      UserProfileTestMode.testUser;
}
