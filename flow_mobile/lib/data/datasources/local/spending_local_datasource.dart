import 'package:flow_mobile/domain/entities/date_spending_statistics.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Local data source interface for spending operations
/// Abstracts Hive storage operations
abstract class SpendingLocalDataSource {
  /// Get spending statistics for a specific date
  Future<DateSpendingStatistics?> getSpending(DateTime date);
  
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

/// Implementation of SpendingLocalDataSource using Hive
class SpendingLocalDataSourceImpl implements SpendingLocalDataSource {
  final Box<DateSpendingStatistics> _spendingBox;

  SpendingLocalDataSourceImpl({required Box<DateSpendingStatistics> spendingBox}) 
      : _spendingBox = spendingBox;

  @override
  Future<DateSpendingStatistics?> getSpending(DateTime date) async {
    final key = _dateToKey(date);
    return _spendingBox.get(key);
  }

  @override
  Future<List<DateSpendingStatistics>> getSpendingRange(
    DateTime fromDate,
    DateTime toDate,
  ) async {
    return _spendingBox.values
        .where((spending) =>
            spending.date.isAfter(fromDate.subtract(const Duration(days: 1))) &&
            spending.date.isBefore(toDate.add(const Duration(days: 1))))
        .toList();
  }

  @override
  Future<void> createSpending(DateSpendingStatistics spending) async {
    final key = _dateToKey(spending.date);
    await _spendingBox.put(key, spending);
  }

  @override
  Future<void> updateSpending(DateSpendingStatistics spending) async {
    final key = _dateToKey(spending.date);
    await _spendingBox.put(key, spending);
  }

  @override
  Future<void> deleteSpending(DateTime date) async {
    final key = _dateToKey(date);
    await _spendingBox.delete(key);
  }

  @override
  Future<List<String>> getSpendingCategories() async {
    // Placeholder implementation - in real app this would extract categories from transactions
    // For now, return common spending categories
    return [
      'Food & Dining',
      'Transportation',
      'Shopping',
      'Entertainment',
      'Bills & Utilities',
      'Healthcare',
      'Travel',
      'Education',
      'Personal Care',
      'Other'
    ];
  }

  /// Helper method to convert date to storage key
  String _dateToKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}