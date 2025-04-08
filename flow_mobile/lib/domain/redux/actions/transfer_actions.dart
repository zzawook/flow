import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/entities/transfer_receivable.dart';

class SelectFromBankAccountAction {
  final BankAccount bankAccount;

  SelectFromBankAccountAction(this.bankAccount);
}

class SelectToBankAccountAction {
  final TransferReceivable bankAccount;

  SelectToBankAccountAction(this.bankAccount);
}

class SelectNetworkAction {
  final String network;

  SelectNetworkAction(this.network);
}

class EnterAmountAction {
  final int amount;

  EnterAmountAction(this.amount);
}

class CustomizeRemarksAction {
  final String remarks;

  CustomizeRemarksAction(this.remarks);
}

class CancelTransferAction {
  CancelTransferAction();
}

class SubmitTransferAction {
  SubmitTransferAction();
}