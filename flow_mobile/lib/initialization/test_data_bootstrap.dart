import 'package:flow_mobile/domain/entity/notification_setting.dart';
import 'package:flow_mobile/domain/entity/user.dart';
import 'package:flow_mobile/domain/manager/bank_account_manager.dart';
import 'package:flow_mobile/domain/manager/bank_account_manager_impl.dart';
import 'package:flow_mobile/domain/manager/bank_manager.dart';
import 'package:flow_mobile/domain/manager/bank_manager_impl.dart';
import 'package:flow_mobile/domain/manager/notification_manager.dart';
import 'package:flow_mobile/domain/manager/notification_manager_impl.dart';
import 'package:flow_mobile/domain/manager/setting_manager.dart';
import 'package:flow_mobile/domain/manager/setting_manager_impl.dart';
import 'package:flow_mobile/domain/manager/transaction_manager.dart';
import 'package:flow_mobile/domain/manager/transaction_manager_impl.dart';
import 'package:flow_mobile/domain/manager/transfer_receiveble_manager.dart';
import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/entity/bank_account.dart';
import 'package:flow_mobile/domain/entity/notification.dart';
import 'package:flow_mobile/domain/entity/paynow_recipient.dart';
import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/manager/transfer_receiveble_manager_impl.dart';
import 'package:flow_mobile/domain/manager/user_manager.dart';
import 'package:flow_mobile/domain/manager/user_manager_impl.dart';

class TestDataBootstrap {

  static Future<bool> bootstrapHiveWithTestData() async {
    bootstrapUserData();
    bool bankAccountDataSuccess = await bootstrapBankAccountData();
    bootstrapSettingData();
    bootstrapTransferReceivableData();
    bool transactionTestBootstrapSuccess = await bootstrapTransactionData();
    bool notificationTestBootstrapSuccess = await bootstrapNotificationData();

    return bankAccountDataSuccess &&
        transactionTestBootstrapSuccess &&
        notificationTestBootstrapSuccess;
  }

  static void bootstrapTransferReceivableData() async {
    TransferReceivebleManager transferReceivableManager =
        await TransferReceivebleManagerImpl.getInstance();

    await transferReceivableManager.clearTransferReceivables();

    TestDataBootstrap.populateTransferReceiableManagerWithTestData(
      transferReceivableManager,
    );
  }

  static Future<bool> bootstrapNotificationData() async {
    NotificationManager notificationManager =
        await NotificationManagerImpl.getInstance();

    await notificationManager.clearNotifications();

    return TestDataBootstrap.populateNotificationManagerWithTestData(
      notificationManager,
    );
  }

  static void bootstrapUserData() async {
    UserManager userManager = await UserManagerImpl.getInstance();

    userManager.updateUser(
      User(
        name: "Kim Jae Hyeok",
        email: 'kjaehyeok21@gmail.com',
        dateOfBirth: DateTime(2002, 1, 25),
        phoneNumber: '88197184',
        nickname: 'Jae Hyeok Kim',
      ),
    );
  }

  static Future<bool> bootstrapBankAccountData() async {
    bool success = await TestDataBootstrap.populateBankAccountManagerWithTestData();
    return success;
  }

  static void bootstrapSettingData() async {
    SettingManager settingManager = await SettingManagerImpl.getInstance();

    settingManager.setFontScale(16);
    settingManager.setLanguage('en');
    settingManager.setTheme('dark');
    settingManager.setNotificationSetting(NotificationSetting.initial());
  }

  static Future<bool> bootstrapTransactionData() async {
    bool success = await TestDataBootstrap.populateTransactionManagerWithTestData();
    return success;
  }

  static Future<bool> populateNotificationManagerWithTestData(
    NotificationManager notificationManager,
  ) async {
    await notificationManager.addNotification(
      Notification(
        id: 1,
        title: 'New Message from Alice',
        body: 'Hey, check out my latest photo!',
        imageUrl:
            'https://img.uxcel.com/tags/notifications-1700498330224-2x.jpg',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
    );
    await notificationManager.addNotification(
      Notification(
        id: 2,
        title: 'Event Reminder',
        body: 'Don’t forget the meeting at 3 PM.',
        imageUrl:
            'https://img.uxcel.com/tags/notifications-1700498330224-2x.jpg',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    );
    await notificationManager.addNotification(
      Notification(
        id: 3,
        title: 'Update Available',
        body: 'A new update is available for download.',
        imageUrl:
            'https://img.uxcel.com/tags/notifications-1700498330224-2x.jpg',
        createdAt: DateTime.now().subtract(
          const Duration(days: 1, minutes: 20),
        ),
      ),
    );
    await notificationManager.addNotification(
      Notification(
        id: 4,
        title: 'Promotion Alert',
        body: 'Check out our latest promotion and save big!',
        imageUrl:
            'https://img.uxcel.com/tags/notifications-1700498330224-2x.jpg',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    );
    await notificationManager.addNotification(
      Notification(
        id: 5,
        title: 'New Feature Available',
        body: 'Check out the new features in the app!',
        imageUrl:
            'https://img.uxcel.com/tags/notifications-1700498330224-2x.jpg',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    );
    await notificationManager.addNotification(
      Notification(
        id: 6,
        title: 'System Maintenance',
        body: 'The system will be down for maintenance tonight.',
        imageUrl:
            'https://img.uxcel.com/tags/notifications-1700498330224-2x.jpg',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
    );
    await notificationManager.addNotification(
      Notification(
        id: 7,
        title: 'New Offers Available',
        body: 'Check out the latest offers in the app!',
        imageUrl:
            'https://img.uxcel.com/tags/notifications-1700498330224-2x.jpg',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    );
    await notificationManager.addNotification(
      Notification(
        id: 8,
        title: 'Security Alert',
        body: 'Unusual activity detected on your account.',
        imageUrl:
            'https://img.uxcel.com/tags/notifications-1700498330224-2x.jpg',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
    );
    await notificationManager.addNotification(
      Notification(
        id: 9,
        title: 'New Payment Method Added',
        body: 'A new payment method has been added to your account.',
        imageUrl:
            'https://img.uxcel.com/tags/notifications-1700498330224-2x.jpg',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
    );
    await notificationManager.addNotification(
      Notification(
        id: 10,
        title: 'Transaction Alert',
        body: 'A new transaction has been made on your account.',
        imageUrl:
            'https://img.uxcel.com/tags/notifications-1700498330224-2x.jpg',
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
      ),
    );
    return true;
  }

  static void populateTransferReceiableManagerWithTestData(
    TransferReceivebleManager transferReceivableManager,
  ) async {
    await transferReceivableManager.addTransferReceivable(
      PayNowRecipient(
        name: "Jaebum Cho",
        phoneNumer: "12345678",
        idNumber: "null",
        bank: Bank.initial(),
        transferCount: 10,
      ),
    );

    await transferReceivableManager.addTransferReceivable(
      PayNowRecipient(
        name: "Woojin Jeon",
        phoneNumer: "23456789",
        idNumber: "null",
        bank: Bank.initial(),
        transferCount: 4,
      ),
    );

    await transferReceivableManager.addTransferReceivable(
      PayNowRecipient(
        name: "Hyeonsung Kim",
        phoneNumer: "34567890",
        idNumber: "null",
        bank: Bank.initial(),
        transferCount: 18,
      ),
    );

    await transferReceivableManager.addTransferReceivable(
      PayNowRecipient(
        name: "Park Jongeun",
        phoneNumer: "82008109",
        idNumber: "null",
        bank: Bank.initial(),
        transferCount: 3,
      ),
    );

    await transferReceivableManager.addTransferReceivable(
      BankAccount(
        accountNumber: "120912384238",
        accountHolder: "Park Jongeun",
        accountName: "Park Jongeun",
        bank: Bank(name: "OCBC", logoPath: "assets/bank_logos/OCBC.png"),
        transferCount: 2,
      ),
    );

    await transferReceivableManager.addTransferReceivable(
      BankAccount(
        accountNumber: "1209987654",
        accountHolder: "Choi Minseok",
        accountName: "Choi Minseok",
        bank: Bank(name: "DBS", logoPath: "assets/bank_logos/DBS.png"),
        transferCount: 2,
      ),
    );

    await transferReceivableManager.addTransferReceivable(
      BankAccount(
        accountNumber: "120934567562",
        accountHolder: "Jeon Seungbin",
        accountName: "Jeon Seungbin",
        bank: Bank(name: "UOB", logoPath: "assets/bank_logos/UOB.png"),
        transferCount: 2,
      ),
    );
  }

  static Future<bool> populateBankAccountManagerWithTestData() async {
    BankAccountManager bankAccountManager =
        await BankAccountManagerImpl.getInstance();
    BankManager bankManager = await BankManagerImpl.getInstance();
    await bankAccountManager.clearBankAccounts();

    await bankAccountManager.createBankAccount(
      BankAccount(
        accountNumber: '1234567890',
        balance: 1000,
        accountHolder: 'Kim Jae Hyeok',
        accountName: 'Savings Account',
        bank: await bankManager.getBank('DBS'),
        transferCount: 0,
      ),
    );

    await bankAccountManager.createBankAccount(
      BankAccount(
        accountNumber: '23456788901',
        balance: 505.1,
        accountHolder: 'Kim Jae Hyeok',
        accountName: 'Savings Account',
        bank: await bankManager.getBank('UOB'),
        transferCount: 0,
      ),
    );

    await bankAccountManager.createBankAccount(
      BankAccount(
        accountNumber: '3456789012',
        balance: 249.11,
        accountHolder: 'Kim Jae Hyeok',
        accountName: 'Savings Account',
        bank: await bankManager.getBank('Maybank'),
        transferCount: 0,
        isHidden: true,
      ),
    );

    return true;
  }

  static Future<bool> populateTransactionManagerWithTestData() async {
    TransactionManager transactionManager =
        await TransactionManagerImpl.getInstance();
    BankAccountManager bankAccountManager =
        await BankAccountManagerImpl.getInstance();
    // ==============================
    // MARCH 2025 TRANSACTIONS (100)
    // ==============================

    ////////////////////////////////////////////////////////////////////////////////
    // For simplicity, we're creating 4 transactions each day for the first 25 days
    // of March. That yields 100 transactions total in March.
    ////////////////////////////////////////////////////////////////////////////////

    // DAY 1

    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 1),
        amount: -12.30,
        name: 'Hawker Breakfast',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 1),
        amount: -2.50,
        name: 'MRT Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 1),
        amount: -25.90,
        name: 'NTUC Groceries',
        category: 'Groceries',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 1),
        amount: -8.00,
        name: 'Lazada Purchase',
        category: 'Shopping',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );

    // DAY 2
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 2),
        amount: -7.60,
        name: 'Toast Box Lunch',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 2),
        amount: -3.20,
        name: 'Bus Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 2),
        amount: -35.50,
        name: 'FairPrice Groceries',
        category: 'Groceries',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 2),
        amount: -52.90,
        name: 'Electric Bill',
        category: 'Bills',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );

    // DAY 3 (Cyclic assignment: IDs 3, 1, 2, 3)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 3),
        amount: -4.00,
        name: 'Coffee Bean',
        category: 'Food',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 3),
        amount: -11.20,
        name: 'Taxi Ride',
        category: 'Transport',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 3),
        amount: -16.00,
        name: 'Movie Ticket',
        category: 'Entertainment',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 3),
        amount: -5.50,
        name: 'Bakeries Purchase',
        category: 'Others',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );

    // DAY 4 (Assignment: 1, 2, 3, 1)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 4),
        amount: -9.90,
        name: 'Subway Meal',
        category: 'Food',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 4),
        amount: -10.00,
        name: 'MRT Top-Up',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 4),
        amount: -40.00,
        name: 'Giant Groceries',
        category: 'Groceries',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 4),
        amount: -18.90,
        name: 'Grab Ride',
        category: 'Transport',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );

    // DAY 5 (Assignment: 2, 3, 1, 2)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 5),
        amount: -5.20,
        name: 'Roasted Chicken Rice',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 5),
        amount: -3.00,
        name: 'EZ-Link Top-Up',
        category: 'Transport',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 5),
        amount: -12.00,
        name: 'Spotify Subscription',
        category: 'Entertainment',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 5),
        amount: -33.00,
        name: 'Watsons Shopping',
        category: 'Shopping',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );

    // DAY 6 (Assignment: 3, 1, 2, 3)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 6),
        amount: -8.10,
        name: 'Mixed Rice Lunch',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 6),
        amount: -20.00,
        name: 'Grab Ride',
        category: 'Transport',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 6),
        amount: -6.50,
        name: 'BreadTalk',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 6),
        amount: -19.90,
        name: 'Cinema Ticket',
        category: 'Entertainment',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );

    // DAY 7 (Assignment: 1, 2, 3, 1)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 7),
        amount: -5.90,
        name: 'Old Chang Kee Snack',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 7),
        amount: -2.50,
        name: 'Bus Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 7),
        amount: -50.00,
        name: 'Uniqlo Shopping',
        category: 'Shopping',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 7),
        amount: 3000.00,
        name: 'Monthly Salary',
        category: 'Salary',
        method: 'Transfer',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );

    // DAY 8 (Assignment: 2, 3, 1, 2)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 8),
        amount: -11.30,
        name: 'Pasta Lunch',
        category: 'Food',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 8),
        amount: -18.00,
        name: 'ComfortDelGro Taxi',
        category: 'Transport',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 8),
        amount: -8.50,
        name: '7-Eleven Snacks',
        category: 'Groceries',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 8),
        amount: -35.00,
        name: 'Zalora Order',
        category: 'Shopping',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );

    // DAY 9 (Assignment: 3, 1, 2, 3)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 9),
        amount: -3.80,
        name: 'Toast Box Breakfast',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 9),
        amount: -2.00,
        name: 'Bus Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 9),
        amount: -15.00,
        name: 'Mobile Game Top-up',
        category: 'Entertainment',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 9),
        amount: -22.00,
        name: 'EZBuy Purchase',
        category: 'Shopping',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );

    // DAY 10 (Assignment: 1, 2, 3, 1)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 10),
        amount: -8.50,
        name: 'Hawker Dinner',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 10),
        amount: -1.50,
        name: 'MRT Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 10),
        amount: -65.00,
        name: 'Movie, Dinner Out',
        category: 'Entertainment',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 10),
        amount: -45.00,
        name: 'Watsons',
        category: 'Shopping',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );

    // DAY 11 (Assignment: 2, 3, 1, 2)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 11),
        amount: -6.20,
        name: 'Bubble Tea',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 11),
        amount: -15.00,
        name: 'Grocery Delivery',
        category: 'Groceries',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 11),
        amount: -20.00,
        name: 'Grab Ride',
        category: 'Transport',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 11),
        amount: -11.50,
        name: 'Movie Snacks',
        category: 'Entertainment',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );

    // DAY 12 (Assignment: 3, 1, 2, 3)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 12),
        amount: -5.50,
        name: 'Cai Fan Lunch',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 12),
        amount: -2.20,
        name: 'Bus Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 12),
        amount: -9.90,
        name: 'iTunes Subscription',
        category: 'Entertainment',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 12),
        amount: -15.30,
        name: 'Daiso Items',
        category: 'Shopping',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );

    // DAY 13 (Assignment: 1, 2, 3, 1)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 13),
        amount: -12.00,
        name: 'Coffeeshop Lunch',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 13),
        amount: -3.50,
        name: 'Train Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 13),
        amount: -25.00,
        name: 'Singtel Bill',
        category: 'Bills',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 13),
        amount: -12.00,
        name: 'H&M Sale Item',
        category: 'Shopping',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );

    // DAY 14 (Assignment: 2, 3, 1, 2)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 14),
        amount: -7.50,
        name: 'Fast Food Lunch',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 14),
        amount: -2.30,
        name: 'MRT Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 14),
        amount: -15.00,
        name: 'Golden Village Ticket',
        category: 'Entertainment',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 14),
        amount: 250.00,
        name: 'Performance Bonus',
        category: 'Salary',
        method: 'Transfer',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );

    // DAY 15 (Assignment: 3, 1, 2, 3)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 15),
        amount: -8.80,
        name: 'Bakery & Coffee',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 15),
        amount: -3.00,
        name: 'Bus Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 15),
        amount: -45.50,
        name: 'FairPrice Xtra',
        category: 'Groceries',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 15),
        amount: -60.00,
        name: 'PUB Utilities Bill',
        category: 'Bills',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );

    // DAY 16 (Assignment: 1, 2, 3, 1)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 16),
        amount: -10.90,
        name: 'Economic Bee Hoon',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 16),
        amount: -2.00,
        name: 'MRT Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 16),
        amount: -13.00,
        name: 'Netflix',
        category: 'Entertainment',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 16),
        amount: -30.00,
        name: 'TopShop T-Shirt',
        category: 'Shopping',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );

    // DAY 17 (Assignment: 2, 3, 1, 2)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 17),
        amount: -9.50,
        name: 'Roti Prata Breakfast',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 17),
        amount: -2.50,
        name: 'Bus Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 17),
        amount: -40.00,
        name: 'Zara Purchase',
        category: 'Shopping',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 17),
        amount: -12.80,
        name: 'Doc Consultation',
        category: 'Medical',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );

    // DAY 18 (Assignment: 3, 1, 2, 3)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 18),
        amount: -18.20,
        name: 'Dine-in Meal',
        category: 'Food',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 18),
        amount: -3.00,
        name: 'Train Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 18),
        amount: -15.00,
        name: 'Snack & Drinks',
        category: 'Groceries',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 18),
        amount: -65.90,
        name: 'Internet Bill',
        category: 'Bills',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );

    // DAY 19 (Assignment: 1, 2, 3, 1)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 19),
        amount: -6.50,
        name: 'Kopi & Toast',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 19),
        amount: -25.00,
        name: 'Grab Ride',
        category: 'Transport',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 19),
        amount: -9.90,
        name: 'Mobile Game IAP',
        category: 'Entertainment',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 19),
        amount: -50.00,
        name: 'Online Shopping',
        category: 'Shopping',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );

    // DAY 20 (Assignment: 2, 3, 1, 2)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 20),
        amount: -4.20,
        name: 'Bubble Tea',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 20),
        amount: -2.10,
        name: 'Bus Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 20),
        amount: -70.00,
        name: 'Uniqlo Clothing',
        category: 'Shopping',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 20),
        amount: -40.00,
        name: 'Doctor Visit',
        category: 'Medical',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );

    // DAY 21 (Assignment: 3, 1, 2, 3)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 21),
        amount: -5.00,
        name: 'Local Kopitiam',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 21),
        amount: -1.90,
        name: 'Train Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 21),
        amount: -10.00,
        name: 'Golden Village',
        category: 'Entertainment',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 21),
        amount: 50.00,
        name: 'Gift from Cousin',
        category: 'Transfer',
        method: 'Transfer',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );

    // DAY 22 (Assignment: 1, 2, 3, 1)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 22),
        amount: -12.00,
        name: 'Bibimbap Lunch',
        category: 'Food',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 22),
        amount: -3.30,
        name: 'MRT & Bus',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 22),
        amount: -35.90,
        name: 'Cold Storage Groceries',
        category: 'Groceries',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 22),
        amount: -75.00,
        name: 'Sports Equipment',
        category: 'Shopping',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );

    // DAY 23 (Assignment: 2, 3, 1, 2)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 23),
        amount: -10.00,
        name: 'Fried Rice Dinner',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 23),
        amount: -25.00,
        name: 'Grab Ride',
        category: 'Transport',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 23),
        amount: -9.90,
        name: 'Nintendo eShop',
        category: 'Entertainment',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 23),
        amount: -18.00,
        name: 'Popular Bookstore',
        category: 'Education',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );

    // DAY 24 (Assignment: 3, 1, 2, 3)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 24),
        amount: -7.50,
        name: 'Prata & Teh Tarik',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 24),
        amount: -3.00,
        name: 'Bus Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 24),
        amount: -99.00,
        name: 'Shopee Electronics',
        category: 'Shopping',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 24),
        amount: -45.60,
        name: 'Dinner & Drinks',
        category: 'Entertainment',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );

    // DAY 25 (Assignment: 1, 2, 3, 1)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 25),
        amount: -14.00,
        name: 'Mixed Vegetable Rice',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 25),
        amount: -30.00,
        name: 'Taxi to Airport',
        category: 'Transport',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 25),
        amount: -5.50,
        name: '7-Eleven Snacks',
        category: 'Groceries',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 4, 25),
        amount: -30.00,
        name: 'Mobile Phone Bill',
        category: 'Bills',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );

    // ==============================
    // APRIL 2025 TRANSACTIONS (100)
    // ==============================

    // DAY 1 (Assignment: 1, 2, 3, 1)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 1),
        amount: -10.50,
        name: 'Economy Rice Lunch',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 1),
        amount: -2.50,
        name: 'Bus Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 1),
        amount: -28.90,
        name: 'FairPrice Groceries',
        category: 'Groceries',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 1),
        amount: -35.00,
        name: 'SingPost Bill Payment',
        category: 'Bills',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );

    // DAY 2 (Assignment: 2, 3, 1, 2)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 2),
        amount: -5.60,
        name: 'Bak Chor Mee',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 2),
        amount: -12.00,
        name: 'CityCab Ride',
        category: 'Transport',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 2),
        amount: -19.00,
        name: 'Netflix Subscription',
        category: 'Entertainment',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 2),
        amount: -100.00,
        name: 'Credit Card Bill Payment',
        category: 'Bills',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );

    // DAY 3 (Assignment: 3, 1, 2, 3)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 3),
        amount: -7.40,
        name: 'Toast Box Breakfast',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 3),
        amount: -3.00,
        name: 'MRT Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 3),
        amount: -23.50,
        name: 'Watsons',
        category: 'Shopping',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 3),
        amount: -15.00,
        name: 'Delivery Tip',
        category: 'Others',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );

    // DAY 4 (Assignment: 1, 2, 3, 1)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 4),
        amount: -9.90,
        name: 'Hawker Center Lunch',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 4),
        amount: -18.00,
        name: 'Grab Ride',
        category: 'Transport',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 4),
        amount: -5.00,
        name: 'Arcade Tokens',
        category: 'Entertainment',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 4),
        amount: -25.00,
        name: 'FairPrice Groceries',
        category: 'Groceries',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );

    // DAY 5 (Assignment: 2, 3, 1, 2)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 5),
        amount: -6.70,
        name: 'Subway Dinner',
        category: 'Food',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 5),
        amount: -2.00,
        name: 'Bus Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 5),
        amount: -12.00,
        name: 'Spotify',
        category: 'Entertainment',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 5),
        amount: -45.00,
        name: 'Amazon Purchase',
        category: 'Shopping',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );

    // DAY 6 (Assignment: 3, 1, 2, 3)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 6),
        amount: -8.10,
        name: 'Mixed Rice Lunch',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 6),
        amount: -35.00,
        name: 'Bill Payment',
        category: 'Bills',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 6),
        amount: -20.00,
        name: 'Grab Ride',
        category: 'Transport',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 6),
        amount: -17.90,
        name: 'Cinema',
        category: 'Entertainment',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );

    // DAY 7 (Assignment: 1, 2, 3, 1)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 7),
        amount: -4.50,
        name: 'Local Kopitiam',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 7),
        amount: -2.50,
        name: 'Bus Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 7),
        amount: -22.00,
        name: 'Arcade & Snacks',
        category: 'Entertainment',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 7),
        amount: 3000.00,
        name: 'Monthly Salary',
        category: 'Salary',
        method: 'Transfer',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );

    // DAY 8 (Assignment: 2, 3, 1, 2)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 8),
        amount: -10.00,
        name: 'Pasta Lunch',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 8),
        amount: -2.20,
        name: 'MRT Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 8),
        amount: -45.00,
        name: 'Uniqlo Sale',
        category: 'Shopping',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 8),
        amount: -3.90,
        name: 'ShareTea Drink',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );

    // DAY 9 (Assignment: 3, 1, 2, 3)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 9),
        amount: -6.50,
        name: 'Porridge Breakfast',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 9),
        amount: -15.00,
        name: 'ComfortDelGro Taxi',
        category: 'Transport',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 9),
        amount: -27.50,
        name: 'NTUC Groceries',
        category: 'Groceries',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 9),
        amount: -8.00,
        name: 'Baskin Robbins',
        category: 'Entertainment',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );

    // DAY 10 (Assignment: 1, 2, 3, 1)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 10),
        amount: -14.00,
        name: 'McDonald’s',
        category: 'Food',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 10),
        amount: -1.50,
        name: 'Bus Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 10),
        amount: -35.00,
        name: 'Movie Tickets',
        category: 'Entertainment',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 10),
        amount: -25.50,
        name: 'Guardian Items',
        category: 'Shopping',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );

    // DAY 11 (Assignment: 2, 3, 1, 2)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 11),
        amount: -2.20,
        name: 'Coffee & Toast',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 11),
        amount: -5.00,
        name: 'Grab Share Ride',
        category: 'Transport',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 11),
        amount: -12.00,
        name: 'Nintendo Online',
        category: 'Entertainment',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 11),
        amount: -15.00,
        name: 'Popular Bookstore',
        category: 'Education',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );

    // DAY 12 (Assignment: 3, 1, 2, 3)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 12),
        amount: -4.70,
        name: 'Bakery Stop',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 12),
        amount: -2.50,
        name: 'Bus Ride',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 12),
        amount: -32.00,
        name: 'Scoot Payment',
        category: 'Transport',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 12),
        amount: -29.90,
        name: 'Mango Sale',
        category: 'Shopping',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );

    // DAY 13 (Assignment: 1, 2, 3, 1)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 13),
        amount: -10.00,
        name: 'Food Court Lunch',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 13),
        amount: -2.20,
        name: 'MRT Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 13),
        amount: -40.00,
        name: 'PUB Utilities Bill',
        category: 'Bills',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 13),
        amount: -8.50,
        name: 'Park Entrance Fee',
        category: 'Entertainment',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );

    // DAY 14 (Assignment: 2, 3, 1, 2)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 14),
        amount: -5.00,
        name: 'Hawker Dinner',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 14),
        amount: -3.00,
        name: 'Train Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 14),
        amount: -12.00,
        name: 'StarHub Bill',
        category: 'Bills',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 14),
        amount: 200.00,
        name: 'Project Bonus',
        category: 'Salary',
        method: 'Transfer',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );

    // DAY 15 (Assignment: 3, 1, 2, 3)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 15),
        amount: -8.20,
        name: 'Teochew Porridge',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 15),
        amount: -1.90,
        name: 'Bus Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 15),
        amount: -55.00,
        name: 'Uniqlo Clothing',
        category: 'Shopping',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 15),
        amount: -10.00,
        name: 'PUB Payment',
        category: 'Bills',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );

    // DAY 16 (Assignment: 1, 2, 3, 1)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 16),
        amount: -9.00,
        name: 'Fish Soup Lunch',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 16),
        amount: -3.00,
        name: 'Grab Share',
        category: 'Transport',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 16),
        amount: -15.00,
        name: 'PUB Bill Top-up',
        category: 'Bills',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 16),
        amount: -6.50,
        name: 'KOI Bubble Tea',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );

    // DAY 17 (Assignment: 2, 3, 1, 2)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 17),
        amount: -10.00,
        name: 'Cai Fan Dinner',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 17),
        amount: -2.10,
        name: 'Train Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 17),
        amount: -32.00,
        name: 'FairPrice Weekly',
        category: 'Groceries',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 17),
        amount: -50.00,
        name: 'Online Purchase',
        category: 'Shopping',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );

    // DAY 18 (Assignment: 3, 1, 2, 3)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 18),
        amount: -7.50,
        name: 'Bak Kut Teh',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 18),
        amount: -20.00,
        name: 'Grab Ride',
        category: 'Transport',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 18),
        amount: -10.00,
        name: 'PSN Subscription',
        category: 'Entertainment',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 18),
        amount: -85.00,
        name: 'Wallet Purchase',
        category: 'Shopping',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );

    // DAY 19 (Assignment: 1, 2, 3, 1)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 19),
        amount: -4.90,
        name: 'Minced Meat Noodles',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 19),
        amount: -2.00,
        name: 'Bus Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 19),
        amount: -25.00,
        name: 'Wallet Top-Up',
        category: 'Others',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 19),
        amount: -9.50,
        name: 'Sentosa Monorail',
        category: 'Entertainment',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );

    // DAY 20 (Assignment: 2, 3, 1, 2)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 20),
        amount: -8.20,
        name: 'Kimchi Fried Rice',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 20),
        amount: -3.00,
        name: 'MRT Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 20),
        amount: -20.00,
        name: 'Grab Ride',
        category: 'Transport',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 20),
        amount: -34.90,
        name: 'Toys Purchase',
        category: 'Shopping',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );

    // DAY 21 (Assignment: 3, 1, 2, 3)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 21),
        amount: -6.00,
        name: 'Malaysian Food Street',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 21),
        amount: -3.00,
        name: 'Bus Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 21),
        amount: -15.00,
        name: 'iTunes Subscription',
        category: 'Entertainment',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 21),
        amount: 88.00,
        name: 'Gift from Sibling',
        category: 'Transfer',
        method: 'Transfer',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );

    // DAY 22 (Assignment: 1, 2, 3, 1)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 22),
        amount: -12.40,
        name: 'Chicken Rice Lunch',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 22),
        amount: -3.30,
        name: 'MRT & Bus',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 22),
        amount: -45.90,
        name: 'Cold Storage',
        category: 'Groceries',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 22),
        amount: -65.00,
        name: 'KINOKUNIYA Books',
        category: 'Education',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );

    // DAY 23 (Assignment: 2, 3, 1, 2)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 23),
        amount: -6.80,
        name: 'Kopi & Toast',
        category: 'Food',
        method: 'Cash',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 23),
        amount: -2.50,
        name: 'Bus Fare',
        category: 'Transport',
        method: 'EZ-Link',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 23),
        amount: -16.00,
        name: 'Golden Village Ticket',
        category: 'Entertainment',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 23),
        amount: -26.00,
        name: 'Uniqlo T-Shirt',
        category: 'Shopping',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('23456788901'),
      ),
    );

    // DAY 24 (Assignment: 3, 1, 2, 3)
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 24),
        amount: -14.00,
        name: 'Fish & Chips',
        category: 'Food',
        method: 'Credit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount('3456789012'),
      ),
    );
    await transactionManager.addTransaction(
      Transaction(
        date: DateTime(2025, 5, 24),
        amount: -20.00,
        name: 'Grab Ride',
        category: 'Transport',
        method: 'Debit Card',
        note: '',
        bankAccount: await bankAccountManager.getBankAccount("1234567890"),
      ),
    );
    return true;
  }
}
