import 'package:flow_mobile/domain/entity/bank_account.dart';
import 'package:flow_mobile/domain/entity/transfer_receivable.dart';

class SelectFromBankAccountAction {
  final BankAccount bankAccount;

  SelectFromBankAccountAction(this.bankAccount);
}

class SelectTransferRecipientAction {
  final TransferReceivable transferReceivable;

  SelectTransferRecipientAction(this.transferReceivable);
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