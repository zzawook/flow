import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flow_mobile/domain/entities/bank.dart';
import 'package:flow_mobile/domain/entities/transfer_receivable.dart';

part 'bank_account.freezed.dart';
part 'bank_account.g.dart';

@freezed
class BankAccount with _$BankAccount implements TransferReceivable {
  const factory BankAccount({
    required String accountNumber,
    required String accountHolder,
    @Default(0.0) double balance,
    required String accountName,
    @JsonKey(fromJson: _bankFromJson, toJson: _bankToJson)
    required Bank bank,
    required int transferCount,
    @Default(false) bool isHidden,
  }) = _BankAccount;

  const BankAccount._();

  // TransferReceivable implementation
  @override
  String get name => accountName;
  
  @override
  String get identifier => accountNumber;
  
  @override
  bool get isAccount => true;
  
  @override
  bool get isPayNow => false;

  factory BankAccount.fromJson(Map<String, dynamic> json) => _$BankAccountFromJson(json);

  factory BankAccount.initial() => BankAccount(
    accountNumber: '123456789',
    accountHolder: 'AccountHolder',
    balance: 0.0,
    accountName: 'My Savings Account',
    bank: Bank.initial(),
    transferCount: 0,
    isHidden: false,
  );
}

Bank _bankFromJson(Map<String, dynamic> json) => Bank.fromJson(json);
Map<String, dynamic> _bankToJson(Bank bank) => bank.toJson();

extension BankAccountExtension on BankAccount {
  String get identifier => accountNumber;

  bool get isAccount => true;

  bool get isPayNow => false;

  String get name => accountName;

  BankAccount setHidden(bool isHidden) {
    return copyWith(isHidden: isHidden);
  }

  bool isEqualTo(BankAccount other) {
    return accountNumber == other.accountNumber && bank.isEqualTo(other.bank);
  }
}