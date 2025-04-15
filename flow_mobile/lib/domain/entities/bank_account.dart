import 'package:flow_mobile/domain/entities/bank.dart';
import 'package:flow_mobile/domain/entities/transfer_receivable.dart';
import 'package:hive_flutter/adapters.dart';

part 'bank_account.g.dart';

@HiveType(typeId: 2)
class BankAccount extends TransferReceivable {
  @HiveField(0)
  final String accountNumber;

  @HiveField(1)
  final String accountHolder;

  @HiveField(2)
  final double balance;

  @HiveField(3)
  final String accountName;

  @HiveField(4)
  @override
  final Bank bank;

  @HiveField(5)
  @override
  final int transferCount;

  BankAccount({
    required this.accountNumber,
    required this.accountHolder,
    this.balance = 0.0,
    required this.accountName,
    required this.bank,
    required this.transferCount,
  });

  factory BankAccount.initial() => BankAccount(
    accountNumber: '123456789',
    accountHolder: 'AccountHolder',
    balance: 0.0,
    accountName: 'My Savings Account',
    bank: Bank.initial(),
    transferCount: 0
  );

  @override
  String get identifier {
    return accountNumber;
  }

  @override
  bool get isAccount {
    return true;
  }

  @override
  bool get isPayNow {
    return false;
  }

  @override
  String get name {
    return accountName;
  }
}
