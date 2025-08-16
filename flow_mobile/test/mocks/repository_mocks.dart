import 'package:mockito/annotations.dart';
import 'package:flow_mobile/domain/repositories/transaction_repository.dart';
import 'package:flow_mobile/domain/repositories/user_repository.dart';
import 'package:flow_mobile/domain/repositories/bank_repository.dart';
import 'package:flow_mobile/domain/repositories/settings_repository.dart';
import 'package:flow_mobile/domain/repositories/account_repository.dart';
import 'package:flow_mobile/domain/repositories/spending_repository.dart';
import 'package:flow_mobile/domain/repositories/transfer_repository.dart';
import 'package:flow_mobile/domain/repositories/notification_repository.dart';
import 'package:flow_mobile/domain/repositories/auth_repository.dart';

@GenerateMocks([
  TransactionRepository,
  UserRepository,
  BankRepository,
  SettingsRepository,
  AccountRepository,
  SpendingRepository,
  TransferRepository,
  NotificationRepository,
  AuthRepository,
])
void main() {
  // This file is used to generate mock classes for repositories
  // Run: flutter packages pub run build_runner build
}