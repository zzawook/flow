import 'package:flow_mobile/domain/entities/bank_account.dart';

class TransferState {
  final BankAccount fromAccount;
  final BankAccount toAccount;
  final int amount;
  final String remarks;
  final String network;

  TransferState({
    required this.fromAccount,
    required this.toAccount,
    this.amount = 0,
    this.remarks = '',
    this.network = 'PAYNOW',
  });

  factory TransferState.initial() => TransferState(
    fromAccount: BankAccount.initial(),
    toAccount: BankAccount.initial(),
  );
}
