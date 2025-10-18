import 'package:flow_mobile/domain/entity/recurring_spending.dart';

/// Test data generator for RecurringSpending
/// Provides various scenarios for UI testing without backend dependency
class RecurringSpendingTestData {
  /// Generate a single recurring spending item (Netflix subscription)
  /// Use case: Test basic rendering and single item layout
  static List<RecurringSpending> getSingleItem(DateTime month) {
    return [
      RecurringSpending(
        id: 1,
        displayName: 'Netflix Subscription',
        category: 'Entertainment',
        brandDomain: 'netflix.com',
        brandName: 'Netflix',
        expectedAmount: 15.99,
        nextTransactionDate: DateTime(month.year, month.month, 15),
        lastTransactionDate: DateTime(month.year, month.month - 1, 15),
        intervalDays: 30,
        occurrenceCount: 12,
        transactionIds: [1001, 1002, 1003],
        year: month.year,
        month: month.month,
      ),
    ];
  }

  /// Generate multiple diverse recurring spending items (6 items)
  /// Use case: Test scrolling, category variety, amount formatting
  static List<RecurringSpending> getMultipleItems(DateTime month) {
    return [
      // Monthly subscription - Entertainment
      RecurringSpending(
        id: 1,
        displayName: 'Netflix Subscription',
        category: 'Entertainment',
        brandDomain: 'netflix.com',
        brandName: 'Netflix',
        expectedAmount: 15.99,
        nextTransactionDate: DateTime(month.year, month.month, 15),
        lastTransactionDate: DateTime(month.year, month.month - 1, 15),
        intervalDays: 30,
        occurrenceCount: 12,
        transactionIds: [1001, 1002, 1003],
        year: month.year,
        month: month.month,
      ),

      // Monthly subscription - Entertainment (Music)
      RecurringSpending(
        id: 2,
        displayName: 'Spotify Premium',
        category: 'Entertainment',
        brandDomain: 'spotify.com',
        brandName: 'Spotify',
        expectedAmount: 9.99,
        nextTransactionDate: DateTime(month.year, month.month, 5),
        lastTransactionDate: DateTime(month.year, month.month - 1, 5),
        intervalDays: 30,
        occurrenceCount: 24,
        transactionIds: [2001, 2002, 2003, 2004],
        year: month.year,
        month: month.month,
      ),

      // Weekly spending - Food
      RecurringSpending(
        id: 3,
        displayName: 'Grab Food Delivery',
        category: 'Food',
        brandDomain: 'grab.com',
        brandName: 'Grab',
        expectedAmount: 25.50,
        nextTransactionDate: DateTime(month.year, month.month, 8),
        lastTransactionDate: DateTime(month.year, month.month, 1),
        intervalDays: 7,
        occurrenceCount: 48,
        transactionIds: [3001, 3002, 3003, 3004, 3005, 3006],
        year: month.year,
        month: month.month,
      ),

      // Monthly bill - Utilities
      RecurringSpending(
        id: 4,
        displayName: 'SP Utilities Bill',
        category: 'Utilities',
        brandDomain: 'spgroup.com.sg',
        brandName: 'SP Group',
        expectedAmount: 120.00,
        nextTransactionDate: DateTime(month.year, month.month, 20),
        lastTransactionDate: DateTime(month.year, month.month - 1, 20),
        intervalDays: 30,
        occurrenceCount: 18,
        transactionIds: [4001, 4002, 4003],
        year: month.year,
        month: month.month,
      ),

      // Monthly membership - Health
      RecurringSpending(
        id: 5,
        displayName: 'Fitness First Gym',
        category: 'Health',
        brandDomain: 'fitnessfirst.com.sg',
        brandName: 'Fitness First',
        expectedAmount: 89.00,
        nextTransactionDate: DateTime(month.year, month.month, 1),
        lastTransactionDate: DateTime(month.year, month.month - 1, 1),
        intervalDays: 30,
        occurrenceCount: 6,
        transactionIds: [5001, 5002],
        year: month.year,
        month: month.month,
      ),

      // Monthly bill - Telecommunication
      RecurringSpending(
        id: 6,
        displayName: 'Singtel Mobile Plan',
        category: 'Telecommunication',
        brandDomain: 'singtel.com',
        brandName: 'Singtel',
        expectedAmount: 45.00,
        nextTransactionDate: DateTime(month.year, month.month, 10),
        lastTransactionDate: DateTime(month.year, month.month - 1, 10),
        intervalDays: 30,
        occurrenceCount: 36,
        transactionIds: [6001, 6002, 6003, 6004],
        year: month.year,
        month: month.month,
      ),
    ];
  }

  /// Generate edge case scenarios for stress testing
  /// Use case: Test boundary conditions, text truncation, unusual intervals
  static List<RecurringSpending> getEdgeCases(DateTime month) {
    return [
      // Edge case 1: Very long display name (tests truncation)
      RecurringSpending(
        id: 101,
        displayName:
            'This is an extremely long recurring transaction name that should definitely be truncated properly by the UI component',
        category: 'Shopping',
        brandDomain: null, // Tests fallback to category icon
        brandName: null,
        expectedAmount: 299.99,
        nextTransactionDate: DateTime(month.year, month.month, 12),
        lastTransactionDate: DateTime(month.year, month.month - 1, 12),
        intervalDays: 30,
        occurrenceCount: 3,
        transactionIds: [101001, 101002],
        year: month.year,
        month: month.month,
      ),

      // Edge case 2: Daily recurring expense (unusual frequency)
      RecurringSpending(
        id: 102,
        displayName: 'Daily Coffee Shop',
        category: 'Food',
        brandDomain: 'starbucks.com',
        brandName: 'Starbucks',
        expectedAmount: 6.50,
        nextTransactionDate: DateTime(
          month.year,
          month.month,
          DateTime.now().day + 1,
        ),
        lastTransactionDate: DateTime(
          month.year,
          month.month,
          DateTime.now().day,
        ),
        intervalDays: 1,
        occurrenceCount: 180,
        transactionIds: List.generate(30, (i) => 102000 + i),
        year: month.year,
        month: month.month,
      ),

      // Edge case 3: Quarterly payment (90 days interval)
      RecurringSpending(
        id: 103,
        displayName: 'Quarterly Insurance',
        category: 'Insurance',
        brandDomain: null,
        brandName: null,
        expectedAmount: 450.00,
        nextTransactionDate: DateTime(month.year, month.month + 3, 1),
        lastTransactionDate: DateTime(month.year, month.month - 3, 1),
        intervalDays: 90,
        occurrenceCount: 4,
        transactionIds: [103001, 103002],
        year: month.year,
        month: month.month,
      ),

      // Edge case 4: Bi-monthly subscription (60 days)
      RecurringSpending(
        id: 104,
        displayName: 'Bi-Monthly Service',
        category: 'Others',
        brandDomain: 'example.com',
        brandName: 'Example Service',
        expectedAmount: 75.00,
        nextTransactionDate: DateTime(month.year, month.month + 2, 5),
        lastTransactionDate: DateTime(month.year, month.month, 5),
        intervalDays: 60,
        occurrenceCount: 6,
        transactionIds: [104001, 104002],
        year: month.year,
        month: month.month,
      ),

      // Edge case 5: Custom interval (every 17 days - unusual)
      RecurringSpending(
        id: 105,
        displayName: 'Custom Interval Payment',
        category: 'Finance',
        brandDomain: null,
        brandName: null,
        expectedAmount: 33.33,
        nextTransactionDate: DateTime(month.year, month.month, 17),
        lastTransactionDate: DateTime(month.year, month.month, 1),
        intervalDays: 17,
        occurrenceCount: 10,
        transactionIds: [105001, 105002, 105003],
        year: month.year,
        month: month.month,
      ),

      // Edge case 6: Micro amount (tests decimal formatting)
      RecurringSpending(
        id: 106,
        displayName: 'Micro Transaction',
        category: 'Others',
        brandDomain: null,
        brandName: null,
        expectedAmount: 0.01,
        nextTransactionDate: DateTime(month.year, month.month, 25),
        lastTransactionDate: DateTime(month.year, month.month - 1, 25),
        intervalDays: 30,
        occurrenceCount: 12,
        transactionIds: [106001],
        year: month.year,
        month: month.month,
      ),

      // Edge case 7: Large amount (tests number formatting)
      RecurringSpending(
        id: 107,
        displayName: 'Premium Service',
        category: 'Finance',
        brandDomain: 'premium.com',
        brandName: 'Premium',
        expectedAmount: 9999.99,
        nextTransactionDate: DateTime(month.year, month.month, 28),
        lastTransactionDate: DateTime(month.year, month.month - 1, 28),
        intervalDays: 30,
        occurrenceCount: 2,
        transactionIds: [107001, 107002],
        year: month.year,
        month: month.month,
      ),
    ];
  }

  /// Get test data based on mode
  static List<RecurringSpending> getDataForMode(String mode, DateTime month) {
    switch (mode.toLowerCase()) {
      case 'single':
        return getSingleItem(month);
      case 'multiple':
        return getMultipleItems(month);
      case 'edge':
      case 'edgecases':
        return getEdgeCases(month);
      default:
        return getMultipleItems(month);
    }
  }
}


