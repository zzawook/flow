import 'package:flutter_test/flutter_test.dart';
import 'package:flow_mobile/domain/entities/entities.dart';

void main() {
  group('Freezed Entities Tests', () {
    test('User entity should work correctly', () {
      // Test creation
      final user = User(
        name: 'John Doe',
        email: 'john@example.com',
        dateOfBirth: DateTime(1990, 1, 1),
        phoneNumber: '+1234567890',
        nickname: 'Johnny',
      );

      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');

      // Test copyWith
      final updatedUser = user.copyWith(nickname: 'John');
      expect(updatedUser.nickname, 'John');
      expect(updatedUser.name, 'John Doe'); // Other fields unchanged

      // Test JSON serialization
      final json = user.toJson();
      final userFromJson = User.fromJson(json);
      expect(userFromJson, user);

      // Test initial factory
      final initialUser = User.initial();
      expect(initialUser.name, '');
      expect(initialUser.email, '');
    });

    test('Bank entity should work correctly', () {
      final bank = Bank(name: 'DBS', logoPath: 'assets/bank_logos/DBS.png');
      
      expect(bank.name, 'DBS');
      expect(bank.logoPath, 'assets/bank_logos/DBS.png');

      // Test JSON serialization
      final json = bank.toJson();
      final bankFromJson = Bank.fromJson(json);
      expect(bankFromJson, bank);

      // Test initial factory
      final initialBank = Bank.initial();
      expect(initialBank.name, '');

      // Test equality method
      final bank2 = Bank(name: 'DBS', logoPath: 'different_path.png');
      expect(bank.isEqualTo(bank2), true);
    });

    test('BankAccount entity should work correctly', () {
      final bank = Bank.initial();
      final bankAccount = BankAccount(
        accountNumber: '123456789',
        accountHolder: 'John Doe',
        balance: 1000.0,
        accountName: 'Savings Account',
        bank: bank,
        transferCount: 5,
        isHidden: false,
      );

      expect(bankAccount.accountNumber, '123456789');
      expect(bankAccount.balance, 1000.0);

      // Test extension methods
      expect(bankAccount.identifier, '123456789');
      expect(bankAccount.isAccount, true);
      expect(bankAccount.isPayNow, false);
      expect(bankAccount.name, 'Savings Account');

      // Test copyWith
      final hiddenAccount = bankAccount.copyWith(isHidden: true);
      expect(hiddenAccount.isHidden, true);
      expect(hiddenAccount.balance, 1000.0); // Other fields unchanged

      // Test setHidden method
      final hiddenAccount2 = bankAccount.setHidden(true);
      expect(hiddenAccount2.isHidden, true);

      // Test JSON serialization
      final json = bankAccount.toJson();
      final accountFromJson = BankAccount.fromJson(json);
      expect(accountFromJson, bankAccount);

      // Test initial factory
      final initialAccount = BankAccount.initial();
      expect(initialAccount.accountNumber, '123456789');
      expect(initialAccount.balance, 0.0);
    });

    test('Transaction entity should work correctly', () {
      final bank = Bank.initial();
      final bankAccount = BankAccount.initial();
      final transaction = Transaction(
        name: 'Coffee Purchase',
        amount: 5.50,
        bankAccount: bankAccount,
        category: 'Food & Beverage',
        date: DateTime(2024, 1, 1),
        method: 'Card',
        note: 'Morning coffee',
      );

      expect(transaction.name, 'Coffee Purchase');
      expect(transaction.amount, 5.50);
      expect(transaction.category, 'Food & Beverage');

      // Test JSON serialization
      final json = transaction.toJson();
      final transactionFromJson = Transaction.fromJson(json);
      expect(transactionFromJson, transaction);
    });

    test('PayNowRecipient entity should work correctly', () {
      final bank = Bank.initial();
      final recipient = PayNowRecipient(
        name: 'Jane Doe',
        phoneNumber: '+1234567890',
        idNumber: 'S1234567A',
        bank: bank,
        transferCount: 3,
      );

      expect(recipient.name, 'Jane Doe');
      expect(recipient.phoneNumber, '+1234567890');

      // Test extension methods
      expect(recipient.identifier, '+1234567890');
      expect(recipient.isAccount, false);
      expect(recipient.isPayNow, true);

      // Test JSON serialization
      final json = recipient.toJson();
      final recipientFromJson = PayNowRecipient.fromJson(json);
      expect(recipientFromJson, recipient);

      // Test initial factory
      final initialRecipient = PayNowRecipient.initial();
      expect(initialRecipient.name, '');
      expect(initialRecipient.phoneNumber, '');
    });

    test('Settings entity should work correctly', () {
      final settings = Settings(
        language: 'en',
        theme: 'dark',
        fontScale: 1.2,
        notification: true,
      );

      expect(settings.language, 'en');
      expect(settings.theme, 'dark');
      expect(settings.fontScale, 1.2);

      // Test copyWith
      final updatedSettings = settings.copyWith(theme: 'light');
      expect(updatedSettings.theme, 'light');
      expect(updatedSettings.language, 'en'); // Other fields unchanged

      // Test JSON serialization
      final json = settings.toJson();
      final settingsFromJson = Settings.fromJson(json);
      expect(settingsFromJson, settings);

      // Test initial factory
      final initialSettings = Settings.initial();
      expect(initialSettings.language, 'en');
      expect(initialSettings.theme, 'light');
      expect(initialSettings.fontScale, 1.0);
      expect(initialSettings.notification, true);
    });

    test('NotificationSetting entity should work correctly', () {
      final notificationSetting = NotificationSetting(
        masterEnabled: true,
        insightNotificationEnabled: false,
        periodicNotificationEnabled: true,
        periodicNotificationAutoEnabled: false,
        periodicNotificationCron: ['0 9 * * 1'],
      );

      expect(notificationSetting.masterEnabled, true);
      expect(notificationSetting.insightNotificationEnabled, false);

      // Test copyWith
      final updated = notificationSetting.copyWith(insightNotificationEnabled: true);
      expect(updated.insightNotificationEnabled, true);
      expect(updated.masterEnabled, true); // Other fields unchanged

      // Test JSON serialization
      final json = notificationSetting.toJson();
      final fromJson = NotificationSetting.fromJson(json);
      expect(fromJson, notificationSetting);

      // Test initial factory
      final initial = NotificationSetting.initial();
      expect(initial.masterEnabled, true);
      expect(initial.periodicNotificationCron, ['0 21 * * 0']);
    });

    test('Notification entity should work correctly', () {
      final notification = Notification(
        id: 1,
        title: 'Test Notification',
        body: 'This is a test notification',
        imageUrl: 'https://example.com/image.png',
        action: 'open_app',
        createdAt: DateTime(2024, 1, 1),
        isChecked: false,
      );

      expect(notification.id, 1);
      expect(notification.title, 'Test Notification');
      expect(notification.isChecked, false);

      // Test copyWith
      final checkedNotification = notification.copyWith(isChecked: true);
      expect(checkedNotification.isChecked, true);
      expect(checkedNotification.title, 'Test Notification'); // Other fields unchanged

      // Test JSON serialization
      final json = notification.toJson();
      final fromJson = Notification.fromJson(json);
      expect(fromJson, notification);
    });

    test('DateSpendingStatistics entity should work correctly', () {
      final stats = DateSpendingStatistics(
        income: 1000.0,
        expense: 500.0,
        date: DateTime(2024, 1, 1),
      );

      expect(stats.income, 1000.0);
      expect(stats.expense, 500.0);

      // Test JSON serialization
      final json = stats.toJson();
      final fromJson = DateSpendingStatistics.fromJson(json);
      expect(fromJson, stats);
    });
  });
}