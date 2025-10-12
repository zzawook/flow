import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/entity/bank_account.dart';
import 'package:flow_mobile/domain/entity/card.dart';
import 'package:flow_mobile/domain/entity/recurring_spending.dart';
import 'package:flow_mobile/domain/entity/transaction.dart';

/// Generates realistic demo data for onboarding experience
/// All dates are relative to current date to ensure data always appears recent
class DemoDataGenerator {
  static final now = DateTime.now();
  static final currentMonth = DateTime(now.year, now.month);

  /// Generate sample bank accounts
  static List<BankAccount> generateBankAccounts() {
    return [
      BankAccount(
        accountNumber: '1234567890',
        accountHolder: 'Demo User',
        balance: 5420.50,
        accountName: 'DBS Savings Account',
        bank: Bank(name: 'DBS', bankId: 1),
        transferCount: 12,
        accountType: 'SAVINGS',
      ),
      BankAccount(
        accountNumber: '0987654321',
        accountHolder: 'Demo User',
        balance: 2150.75,
        accountName: 'OCBC Current Account',
        bank: Bank(name: 'OCBC', bankId: 2),
        transferCount: 8,
        accountType: 'CURRENT',
      ),
      BankAccount(
        accountNumber: '5555666677',
        accountHolder: 'Demo User',
        balance: 8900.00,
        accountName: 'UOB Savings Account',
        bank: Bank(name: 'UOB', bankId: 3),
        transferCount: 5,
        accountType: 'SAVINGS',
      ),
    ];
  }

  /// Generate sample cards
  static List<Card> generateCards() {
    return [
      Card(
        cardNumber: '4532 **** **** 1234',
        cardName: 'Demo User',
        cardType: 'CREDIT',
        bank: Bank(name: 'DBS', bankId: 1),
        balance: -1250.30,
      ),
      Card(
        cardNumber: '5412 **** **** 9876',
        cardName: 'Demo User',
        cardType: 'DEBIT',
        bank: Bank(name: 'OCBC', bankId: 2),
        balance: 0.0,
      ),
    ];
  }

  /// Generate sample transactions for current month (no future dates)
  static List<Transaction> generateTransactions(List<BankAccount> accounts) {
    final transactions = <Transaction>[];
    int idCounter = 1000;

    // Helper to create transaction
    Transaction? createTx({
      required String name,
      required double amount,
      required BankAccount account,
      required String category,
      required int daysAgo,
      String method = 'CARD',
      String note = '',
      bool isIncluded = true,
      String brandDomain = '',
      String brandName = '',
    }) {
      final date = now.subtract(Duration(days: daysAgo));
      // Only include if date is within current month and not in future
      if (date.month != now.month || date.isAfter(now)) {
        return null;
      }
      return Transaction(
        id: idCounter++,
        name: name,
        amount: amount,
        bankAccount: account,
        category: category,
        date: date,
        method: method,
        note: note,
        isIncludedInSpendingOrIncome: isIncluded,
        brandDomain: brandDomain,
        brandName: brandName,
      );
    }

    final dbsAccount = accounts[0];
    final ocbcAccount = accounts[1];
    final uobAccount = accounts[2];

    // Grocery
    final grocery1 = createTx(
      name: 'FairPrice Supermarket',
      amount: -85.50,
      account: dbsAccount,
      category: 'Grocery',
      daysAgo: 2,
      brandName: 'FairPrice',
    );
    if (grocery1 != null) transactions.add(grocery1);

    final grocery2 = createTx(
      name: 'Cold Storage',
      amount: -125.80,
      account: ocbcAccount,
      category: 'Grocery',
      daysAgo: 7,
      brandName: 'Cold Storage',
    );
    if (grocery2 != null) transactions.add(grocery2);

    final grocery3 = createTx(
      name: 'Giant Hypermarket',
      amount: -67.20,
      account: dbsAccount,
      category: 'Grocery',
      daysAgo: 14,
      brandName: 'Giant',
    );
    if (grocery3 != null) transactions.add(grocery3);

    final grocery4 = createTx(
      name: 'Sheng Siong',
      amount: -42.90,
      account: dbsAccount,
      category: 'Grocery',
      daysAgo: 21,
      brandName: 'Sheng Siong',
    );
    if (grocery4 != null) transactions.add(grocery4);

    // Food
    final dining1 = createTx(
      name: 'Tim Ho Wan',
      amount: -28.50,
      account: dbsAccount,
      category: 'Food',
      daysAgo: 1,
      brandName: 'Tim Ho Wan',
    );
    if (dining1 != null) transactions.add(dining1);

    final dining2 = createTx(
      name: 'Paradise Dynasty',
      amount: -65.00,
      account: ocbcAccount,
      category: 'Food',
      daysAgo: 3,
      brandName: 'Paradise Dynasty',
    );
    if (dining2 != null) transactions.add(dining2);

    final dining3 = createTx(
      name: 'Starbucks',
      amount: -12.80,
      account: dbsAccount,
      category: 'Food',
      daysAgo: 4,
      brandName: 'Starbucks',
    );
    if (dining3 != null) transactions.add(dining3);

    final dining4 = createTx(
      name: 'Toast Box',
      amount: -8.50,
      account: dbsAccount,
      category: 'Food',
      daysAgo: 5,
      brandName: 'Toast Box',
    );
    if (dining4 != null) transactions.add(dining4);

    final dining5 = createTx(
      name: 'Din Tai Fung',
      amount: -85.60,
      account: ocbcAccount,
      category: 'Food',
      daysAgo: 10,
      brandName: 'Din Tai Fung',
    );
    if (dining5 != null) transactions.add(dining5);

    final dining6 = createTx(
      name: 'Ya Kun Kaya Toast',
      amount: -7.20,
      account: dbsAccount,
      category: 'Food',
      daysAgo: 12,
      brandName: 'Ya Kun',
    );
    if (dining6 != null) transactions.add(dining6);

    // Transportation
    final transport1 = createTx(
      name: 'SimplyGo - MRT',
      amount: -25.40,
      account: dbsAccount,
      category: 'Transportation',
      daysAgo: 1,
      brandName: 'SimplyGo',
    );
    if (transport1 != null) transactions.add(transport1);

    final transport2 = createTx(
      name: 'Grab - Ride',
      amount: -18.50,
      account: ocbcAccount,
      category: 'Transportation',
      daysAgo: 6,
      brandName: 'Grab',
    );
    if (transport2 != null) transactions.add(transport2);

    final transport3 = createTx(
      name: 'SimplyGo - Bus',
      amount: -15.20,
      account: dbsAccount,
      category: 'Transportation',
      daysAgo: 8,
      brandName: 'SimplyGo',
    );
    if (transport3 != null) transactions.add(transport3);

    final transport4 = createTx(
      name: 'ComfortDelGro Taxi',
      amount: -32.00,
      account: ocbcAccount,
      category: 'Transportation',
      daysAgo: 15,
      brandName: 'ComfortDelGro',
    );
    if (transport4 != null) transactions.add(transport4);

    // Shopping
    final shopping1 = createTx(
      name: 'Uniqlo',
      amount: -125.00,
      account: ocbcAccount,
      category: 'Shopping',
      daysAgo: 5,
      brandName: 'Uniqlo',
    );
    if (shopping1 != null) transactions.add(shopping1);

    final shopping2 = createTx(
      name: 'Lazada',
      amount: -89.90,
      account: dbsAccount,
      category: 'Shopping',
      daysAgo: 9,
      brandName: 'Lazada',
    );
    if (shopping2 != null) transactions.add(shopping2);

    final shopping3 = createTx(
      name: 'Popular Bookstore',
      amount: -45.50,
      account: dbsAccount,
      category: 'Shopping',
      daysAgo: 16,
      brandName: 'Popular',
    );
    if (shopping3 != null) transactions.add(shopping3);

    // Entertainment
    final entertainment1 = createTx(
      name: 'Netflix',
      amount: -16.98,
      account: dbsAccount,
      category: 'Entertainment',
      daysAgo: 3,
      brandName: 'Netflix',
    );
    if (entertainment1 != null) transactions.add(entertainment1);

    final entertainment2 = createTx(
      name: 'Spotify',
      amount: -9.99,
      account: dbsAccount,
      category: 'Entertainment',
      daysAgo: 5,
      brandName: 'Spotify',
    );
    if (entertainment2 != null) transactions.add(entertainment2);

    final entertainment3 = createTx(
      name: 'Golden Village Cinema',
      amount: -28.00,
      account: ocbcAccount,
      category: 'Entertainment',
      daysAgo: 11,
      brandName: 'Golden Village',
    );
    if (entertainment3 != null) transactions.add(entertainment3);

    // Health
    final healthcare1 = createTx(
      name: 'Guardian Pharmacy',
      amount: -34.80,
      account: dbsAccount,
      category: 'Health',
      daysAgo: 13,
      brandName: 'Guardian',
    );
    if (healthcare1 != null) transactions.add(healthcare1);

    final healthcare2 = createTx(
      name: 'Raffles Medical',
      amount: -65.00,
      account: ocbcAccount,
      category: 'Health',
      daysAgo: 20,
      brandName: 'Raffles Medical',
    );
    if (healthcare2 != null) transactions.add(healthcare2);

    // Utilities
    final utilities1 = createTx(
      name: 'SP Services',
      amount: -125.50,
      account: uobAccount,
      category: 'Utilities',
      daysAgo: 4,
      brandName: 'SP Services',
    );
    if (utilities1 != null) transactions.add(utilities1);

    // Telecommunication
    final utilities2 = createTx(
      name: 'Singtel',
      amount: -65.00,
      account: uobAccount,
      category: 'Telecommunication',
      daysAgo: 10,
      brandName: 'Singtel',
    );
    if (utilities2 != null) transactions.add(utilities2);

    // Transfer (Income)
    final income1 = createTx(
      name: 'Salary Credit',
      amount: 4500.00,
      account: uobAccount,
      category: 'Transfer',
      daysAgo: 25,
      method: 'TRANSFER',
      brandName: 'Employer',
    );
    if (income1 != null) transactions.add(income1);

    final income2 = createTx(
      name: 'Freelance Payment',
      amount: 850.00,
      account: dbsAccount,
      category: 'Transfer',
      daysAgo: 18,
      method: 'TRANSFER',
      brandName: 'Client',
    );
    if (income2 != null) transactions.add(income2);

    // Health (Fitness)
    final fitness1 = createTx(
      name: 'ActiveSG Gym',
      amount: -50.00,
      account: dbsAccount,
      category: 'Health',
      daysAgo: 6,
      brandName: 'ActiveSG',
    );
    if (fitness1 != null) transactions.add(fitness1);

    // Sort by date descending (most recent first)
    transactions.sort((a, b) => b.date.compareTo(a.date));

    return transactions;
  }

  /// Generate sample recurring spending
  static List<RecurringSpending> generateRecurringSpending() {
    return [
      RecurringSpending(
        id: 1,
        displayName: 'Netflix Subscription',
        category: 'Entertainment',
        brandName: 'Netflix',
        expectedAmount: -16.98,
        nextTransactionDate: DateTime(now.year, now.month + 1, 3),
        lastTransactionDate: now.subtract(const Duration(days: 3)),
        intervalDays: 30,
        occurrenceCount: 6,
        transactionIds: [1001, 1012, 1023],
        year: now.year,
        month: now.month,
      ),
      RecurringSpending(
        id: 2,
        displayName: 'Spotify Premium',
        category: 'Entertainment',
        brandName: 'Spotify',
        expectedAmount: -9.99,
        nextTransactionDate: DateTime(now.year, now.month + 1, 5),
        lastTransactionDate: now.subtract(const Duration(days: 5)),
        intervalDays: 30,
        occurrenceCount: 8,
        transactionIds: [1002, 1013],
        year: now.year,
        month: now.month,
      ),
      RecurringSpending(
        id: 3,
        displayName: 'ActiveSG Gym',
        category: 'Health',
        brandName: 'ActiveSG',
        expectedAmount: -50.00,
        nextTransactionDate: DateTime(now.year, now.month + 1, 1),
        lastTransactionDate: now.subtract(const Duration(days: 6)),
        intervalDays: 30,
        occurrenceCount: 4,
        transactionIds: [1003],
        year: now.year,
        month: now.month,
      ),
    ];
  }
}
