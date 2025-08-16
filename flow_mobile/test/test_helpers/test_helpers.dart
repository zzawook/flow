import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/domain/entities/entities.dart';

/// Test helper utilities for creating test data and mocking providers

class TestHelpers {
  /// Creates a test transaction with default values
  static Transaction createTestTransaction({
    String name = 'Test transaction',
    double amount = 100.0,
    BankAccount? bankAccount,
    String category = 'Food',
    DateTime? date,
    String method = 'Card',
    String note = 'Test note',
  }) {
    return Transaction(
      name: name,
      amount: amount,
      bankAccount: bankAccount ?? createTestBankAccount(),
      category: category,
      date: date ?? DateTime.now(),
      method: method,
      note: note,
    );
  }

  /// Creates a test user with default values
  static User createTestUser({
    String name = 'John Doe',
    String email = 'john@example.com',
    DateTime? dateOfBirth,
    String phoneNumber = '+1234567890',
    String nickname = 'Johnny',
  }) {
    return User(
      name: name,
      email: email,
      dateOfBirth: dateOfBirth ?? DateTime(1990, 1, 1),
      phoneNumber: phoneNumber,
      nickname: nickname,
    );
  }

  /// Creates a test bank with default values
  static Bank createTestBank({
    String name = 'Test Bank',
    String logoPath = 'assets/bank_logos/test.png',
  }) {
    return Bank(
      name: name,
      logoPath: logoPath,
    );
  }

  /// Creates a test bank account with default values
  static BankAccount createTestBankAccount({
    String accountNumber = '1234567890',
    String accountHolder = 'John Doe',
    double balance = 1000.0,
    String accountName = 'Test Account',
    Bank? bank,
    int transferCount = 0,
    bool isHidden = false,
  }) {
    return BankAccount(
      accountNumber: accountNumber,
      accountHolder: accountHolder,
      balance: balance,
      accountName: accountName,
      bank: bank ?? createTestBank(),
      transferCount: transferCount,
      isHidden: isHidden,
    );
  }

  /// Creates a test notification setting with default values
  static NotificationSetting createTestNotificationSetting({
    String id = '1',
    NotificationType type = NotificationType.transaction,
    bool isEnabled = true,
    String title = 'Test Notification',
    String description = 'Test notification description',
  }) {
    return NotificationSetting(
      id: id,
      type: type,
      isEnabled: isEnabled,
      title: title,
      description: description,
    );
  }

  /// Creates a ProviderContainer for testing with overrides
  static ProviderContainer createTestContainer({
    List<Override> overrides = const [],
  }) {
    return ProviderContainer(
      overrides: overrides,
    );
  }

  /// Disposes of a ProviderContainer after test
  static void disposeContainer(ProviderContainer container) {
    container.dispose();
  }
}

/// Custom matchers for testing
class TestMatchers {
  /// Matcher for checking if a transaction has specific properties
  static Matcher hasTransactionProperties({
    String? name,
    double? amount,
    String? category,
    String? method,
    String? note,
  }) {
    return predicate<Transaction>((transaction) {
      if (name != null && transaction.name != name) return false;
      if (amount != null && transaction.amount != amount) return false;
      if (category != null && transaction.category != category) return false;
      if (method != null && transaction.method != method) return false;
      if (note != null && transaction.note != note) return false;
      return true;
    });
  }

  /// Matcher for checking if a user has specific properties
  static Matcher hasUserProperties({
    String? name,
    String? email,
    String? phoneNumber,
    String? nickname,
  }) {
    return predicate<User>((user) {
      if (name != null && user.name != name) return false;
      if (email != null && user.email != email) return false;
      if (phoneNumber != null && user.phoneNumber != phoneNumber) return false;
      if (nickname != null && user.nickname != nickname) return false;
      return true;
    });
  }
}