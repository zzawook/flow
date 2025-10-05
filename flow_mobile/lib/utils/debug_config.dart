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

enum CardTestMode { none, multipleItems, singleItem, edgeCases, empty }

class DebugConfig {
  static const bool isDebugMode = true;

  static const RecurringSpendingTestMode recurringSpendingMode =
      RecurringSpendingTestMode.multipleItems;

  static const CardTestMode cardTestMode = CardTestMode.multipleItems;
}
