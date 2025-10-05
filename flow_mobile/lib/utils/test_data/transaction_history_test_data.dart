import 'dart:math';

import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/utils/test_data/bank_account_test_data.dart';

/// Test data for transaction history
/// Provides mock transactions for testing without backend dependency
class TransactionHistoryTestData {
  static final _random = Random(42); // Fixed seed for consistent test data
  static final _dbsAccount = BankAccountTestData.getDBSSavingsAccount();
  static final _ocbcAccount = BankAccountTestData.getOCBCCheckingAccount();

  /// Categories available in the app
  static const _categories = [
    'Food',
    'Entertainment',
    'Shopping',
    'Transportation',
    'Travel',
    'Utilities',
    'Telecommunication',
    'Health',
    'Grocery',
  ];

  /// Merchant names for realistic transactions
  static const _merchants = {
    'Food': [
      'McDonald\'s',
      'Starbucks',
      'Din Tai Fung',
      'Subway',
      'KFC',
      'Pizza Hut',
      'Chipotle',
      'Burger King'
    ],
    'Entertainment': [
      'Netflix',
      'Spotify',
      'Apple Music',
      'YouTube Premium',
      'Disney+',
      'HBO Max'
    ],
    'Shopping': [
      'Amazon',
      'Shopee',
      'Lazada',
      'Uniqlo',
      'H&M',
      'Zara',
      'Nike',
      'Adidas'
    ],
    'Transportation': [
      'Grab',
      'Uber',
      'ComfortDelGro',
      'EZ-Link Top Up',
      'Gojek'
    ],
    'Travel': [
      'Singapore Airlines',
      'Agoda',
      'Booking.com',
      'Airbnb',
      'Expedia'
    ],
    'Utilities': [
      'SP Services',
      'PUB Singapore',
      'City Gas',
      'Electricity Bill'
    ],
    'Telecommunication': [
      'Singtel',
      'StarHub',
      'M1',
      'Circles.Life'
    ],
    'Health': [
      'Guardian Pharmacy',
      'Watsons',
      'Fitness First',
      'ActiveSG Gym',
      'Raffles Medical'
    ],
    'Grocery': [
      'FairPrice',
      'Cold Storage',
      'Giant',
      'Sheng Siong',
      'Prime Supermarket'
    ],
  };

  /// Get a single transaction per month for the last 6 months
  /// Use case: Test basic transaction flow with minimal data
  static List<Transaction> getSingleItemPerMonth() {
    final now = DateTime.now();
    final transactions = <Transaction>[];
    int transactionId = 1000;

    for (int monthsAgo = 5; monthsAgo >= 0; monthsAgo--) {
      final date = DateTime(
        now.year,
        now.month - monthsAgo,
        15, // Mid-month
        12,
        0,
      );

      final category = _categories[monthsAgo % _categories.length];
      final merchants = _merchants[category]!;
      final merchant = merchants[0];

      transactions.add(
        Transaction(
          id: transactionId++,
          name: merchant,
          amount: -50.00 - (monthsAgo * 10.0), // Varying amounts
          bankAccount: monthsAgo.isEven ? _dbsAccount : _ocbcAccount,
          category: category,
          date: date,
          method: 'CARD',
          note: 'Test transaction',
          isIncludedInSpendingOrIncome: true,
          brandDomain: _getBrandDomain(merchant),
          brandName: merchant,
        ),
      );
    }

    return transactions;
  }

  /// Get multiple diverse transactions (~50 per month for 6 months = ~300 total)
  /// Use case: Test full transaction flow with realistic data volume
  static List<Transaction> getMultipleItems() {
    final now = DateTime.now();
    final transactions = <Transaction>[];
    int transactionId = 2000;

    for (int monthsAgo = 5; monthsAgo >= 0; monthsAgo--) {
      final targetMonth = DateTime(now.year, now.month - monthsAgo);
      final daysInMonth = DateTime(targetMonth.year, targetMonth.month + 1, 0).day;

      // Generate ~50 transactions per month
      for (int i = 0; i < 50; i++) {
        final day = 1 + _random.nextInt(daysInMonth);
        final hour = 8 + _random.nextInt(14); // Between 8am and 10pm
        final minute = _random.nextInt(60);

        final date = DateTime(
          targetMonth.year,
          targetMonth.month,
          day,
          hour,
          minute,
        );

        // 90% expenses, 10% income
        final isExpense = _random.nextDouble() > 0.1;
        final category = isExpense
            ? _categories[_random.nextInt(_categories.length)]
            : 'Transfer'; // Income as transfer

        final merchants = isExpense
            ? _merchants[category] ?? ['Unknown Merchant']
            : ['Salary Deposit', 'Transfer In', 'Refund'];
        final merchant = merchants[_random.nextInt(merchants.length)];

        // Expense: -$5 to -$200, Income: $500 to $5000
        final amount = isExpense
            ? -(5.0 + _random.nextDouble() * 195.0)
            : (500.0 + _random.nextDouble() * 4500.0);

        // Round to 2 decimal places
        final roundedAmount = (amount * 100).round() / 100;

        // Alternate between DBS and OCBC accounts
        final account = transactionId.isEven ? _dbsAccount : _ocbcAccount;

        transactions.add(
          Transaction(
            id: transactionId++,
            name: merchant,
            amount: roundedAmount,
            bankAccount: account,
            category: category,
            date: date,
            method: isExpense ? 'CARD' : 'TRANSFER',
            note: isExpense ? 'Purchase' : 'Received',
            isIncludedInSpendingOrIncome: true,
            brandDomain: _getBrandDomain(merchant),
            brandName: merchant,
          ),
        );
      }
    }

    // Sort by date (most recent first)
    transactions.sort((a, b) => b.date.compareTo(a.date));

    return transactions;
  }

  /// Helper to get brand domain from merchant name
  static String _getBrandDomain(String merchant) {
    final domains = {
      'McDonald\'s': 'mcdonalds.com',
      'Starbucks': 'starbucks.com',
      'Netflix': 'netflix.com',
      'Spotify': 'spotify.com',
      'Amazon': 'amazon.com',
      'Grab': 'grab.com',
      'Uber': 'uber.com',
      'Singtel': 'singtel.com',
      'FairPrice': 'fairprice.com.sg',
    };

    return domains[merchant] ?? '';
  }
}

