import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'domain/usecases/transaction/create_transaction_usecase_test.dart' as create_transaction_test;
import 'domain/usecases/transaction/update_transaction_usecase_test.dart' as update_transaction_test;
import 'domain/usecases/transaction/delete_transaction_usecase_test.dart' as delete_transaction_test;
import 'domain/usecases/bank/get_banks_usecase_test.dart' as get_banks_test;
import 'domain/usecases/settings/set_notification_settings_usecase_test.dart' as set_notification_test;
import 'domain/usecases/user/get_user_usecase_test.dart' as get_user_test;
import 'domain/usecases/user/update_user_usecase_test.dart' as update_user_test;
import 'domain/usecases/user/delete_user_usecase_test.dart' as delete_user_test;
import 'domain/usecases/spending/get_spending_statistics_usecase_test.dart' as get_spending_test;
import 'domain/usecases/account/get_bank_accounts_usecase_test.dart' as get_accounts_test;
import 'data/repositories/transaction_repository_impl_test.dart' as transaction_repo_test;
import 'data/repositories/user_repository_impl_test.dart' as user_repo_test;
import 'presentation/providers/transaction_provider_test.dart' as transaction_provider_test;
import 'presentation/providers/user_provider_test.dart' as user_provider_test;

/// Comprehensive test suite for the Flutter app
/// This file runs all unit tests for use cases, repositories, and providers
void main() {
  group('Use Cases Tests', () {
    group('Transaction Use Cases', () {
      create_transaction_test.main();
      update_transaction_test.main();
      delete_transaction_test.main();
    });

    group('Bank Use Cases', () {
      get_banks_test.main();
    });

    group('Settings Use Cases', () {
      set_notification_test.main();
    });

    group('User Use Cases', () {
      get_user_test.main();
      update_user_test.main();
      delete_user_test.main();
    });

    group('Spending Use Cases', () {
      get_spending_test.main();
    });

    group('Account Use Cases', () {
      get_accounts_test.main();
    });
  });

  group('Repository Tests', () {
    transaction_repo_test.main();
    user_repo_test.main();
  });

  group('Provider Tests', () {
    transaction_provider_test.main();
    user_provider_test.main();
  });
}