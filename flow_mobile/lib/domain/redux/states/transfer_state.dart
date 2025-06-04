import 'package:flow_mobile/domain/entity/bank_account.dart';
import 'package:flow_mobile/domain/entity/transfer_receivable.dart';

class TransferState {
  final BankAccount fromAccount;
  final TransferReceivable receiving;
  final int amount;
  final String remarks;
  final String network;

  TransferState({
    required this.fromAccount,
    required this.receiving,
    this.amount = 0,
    this.remarks = '',
    this.network = 'PAYNOW',
  });

  factory TransferState.initial() => TransferState(
    fromAccount: BankAccount.initial(),
    receiving: BankAccount.initial(),
  );
}
