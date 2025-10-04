/// Debug configuration for testing various UI states without backend dependency
///
/// Usage:
/// 1. Set `isDebugMode = true` to enable debug features
/// 2. Change `recurringSpendingMode` to desired test mode
/// 3. Hot reload the app
/// 4. Navigate to Spending screen to see the changes
///
/// IMPORTANT: Set `isDebugMode = false` before production builds!
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

class DebugConfig {
  /// Master switch for all debug features
  /// Set to false for production builds
  static const bool isDebugMode = true;

  /// Current test mode for recurring spending feature
  /// Change this value to test different UI states
  ///
  /// Quick Reference:
  /// - production: Use real API data
  /// - loading: Show loading spinner indefinitely
  /// - error: Show error message
  /// - empty: Show "No recurring spendings found"
  /// - singleItem: Show 1 item (Netflix)
  /// - multipleItems: Show 6 diverse items (recommended for demos)
  /// - edgeCases: Show 7 edge cases (long names, extreme amounts, etc.)
  ///
  /// After changing, hot reload and navigate to Spending screen to see changes.
  /// See lib/utils/test_data/README.md for detailed documentation.
  static const RecurringSpendingTestMode recurringSpendingMode =
      RecurringSpendingTestMode.multipleItems;
}
