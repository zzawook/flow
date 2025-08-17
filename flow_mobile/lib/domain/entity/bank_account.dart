import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/entity/transfer_receivable.dart';
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

  @HiveField(6)
  bool isHidden;

  @HiveField(7)
  final String accountType; // e.g., "SAVINGS", "CURRENT"

  BankAccount({
    required this.accountNumber,
    required this.accountHolder,
    this.balance = 0.0,
    required this.accountName,
    required this.bank,
    required this.transferCount,
    this.isHidden = false,
    required this.accountType,
  });

  factory BankAccount.initial() => BankAccount(
    accountNumber: '123456789',
    accountHolder: 'AccountHolder',
    balance: 0.0,
    accountName: 'My Savings Account',
    bank: Bank.initial(),
    transferCount: 0,
    isHidden: false,
    accountType: 'SAVINGS',
  );

  BankAccount copyWith({
    String? accountNumber,
    String? accountHolder,
    double? balance,
    String? accountName,
    Bank? bank,
    int? transferCount,
    bool? isHidden,
    String? accountType,
  }) => BankAccount(
    accountNumber: accountNumber ?? this.accountNumber,
    accountHolder: accountHolder ?? this.accountHolder,
    balance: balance ?? this.balance,
    accountName: accountName ?? this.accountName,
    bank: bank ?? this.bank,
    transferCount: transferCount ?? this.transferCount,
    isHidden: isHidden ?? this.isHidden,
    accountType: accountType ?? this.accountType,
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

  void setHidden(bool isHidden) {
    this.isHidden = isHidden;
  }

  bool isEqualTo(BankAccount other) {
    return accountNumber == other.accountNumber && bank.isEqualTo(bank);
  }
}
