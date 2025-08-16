import 'package:flow_mobile/domain/entities/date_spending_statistics.dart';

/// Repository interface for spending operations
/// Based on spending use cases and spending statistics entity
abstract class SpendingRepository {
  /// Get spending statistics for a specific date
  Future<DateSpendingStatistics> getSpending(DateTime date);
  
  /// Get spending statistics for a date range
  Future<List<DateSpendingStatistics>> getSpendingRange(
    DateTime fromDate,
    DateTime toDate,
  );
  
  /// Create new spending record
  Future<void> createSpending(DateSpendingStatistics spending);
  
  /// Update existing spending record
  Future<void> updateSpending(DateSpendingStatistics spending);
  
  /// Delete spending record
  Future<void> deleteSpending(DateTime date);
  
  /// Get spending categories
  Future<List<String>> getSpendingCategories();
}