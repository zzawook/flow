/// Test data for Monthly Asset feature debugging
///
/// Usage: Import this in thunks when DebugConfig.isDebugMode is true
library;

class MonthlyAssetTestData {
  /// Returns normal 6-month asset progression data
  static Map<DateTime, double> getMultipleItems() {
    final now = DateTime.now();
    return {
      DateTime(now.year, now.month - 5, 28): 8500.0,
      DateTime(now.year, now.month - 4, 30): 9200.0,
      DateTime(now.year, now.month - 3, 31): 8900.0,
      DateTime(now.year, now.month - 2, 28): 10500.0,
      DateTime(now.year, now.month - 1, 30): 11200.0,
      DateTime(now.year, now.month, now.day): 12000.0,
    };
  }

  /// Returns empty asset data
  static Map<DateTime, double> getEmpty() {
    return {};
  }

  /// Returns edge cases: zero, negative, extreme values
  static Map<DateTime, double> getEdgeCases() {
    final now = DateTime.now();
    return {
      DateTime(now.year, now.month - 5, 28): 0.0, // Zero balance
      DateTime(now.year, now.month - 4, 30): -500.0, // Negative (debt)
      DateTime(now.year, now.month - 3, 31): 0.01, // Very small
      DateTime(now.year, now.month - 2, 28): 999999.99, // Very large
      DateTime(now.year, now.month - 1, 30): 1200.0,
      DateTime(now.year, now.month, now.day): 1500.0,
    };
  }
}

