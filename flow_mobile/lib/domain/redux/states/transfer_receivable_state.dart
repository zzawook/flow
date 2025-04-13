import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/entities/paynow_recipient.dart';
import 'package:flow_mobile/domain/entities/transfer_receivable.dart';

class TransferReceivableState {
  List<TransferReceivable> transferReceivables;
  List<BankAccount> myBankAccounts;

  TransferReceivableState({
    required this.transferReceivables,
    required this.myBankAccounts,
  });
  TransferReceivableState copyWith({
    List<TransferReceivable>? transferReceivables,
    List<BankAccount>? myBankAccounts,
  }) {
    return TransferReceivableState(
      transferReceivables: transferReceivables ?? this.transferReceivables,
      myBankAccounts: myBankAccounts ?? this.myBankAccounts,
    );
  }

  factory TransferReceivableState.initial() =>
      TransferReceivableState(transferReceivables: [], myBankAccounts: []);

  List<PayNowRecipient> getRecommendedPayNow() {
    return transferReceivables
        .where((account) => account.isPayNow && account.transferCount > 0)
        .map((e) => e as PayNowRecipient,)
        .toList();
  }

  List<BankAccount> getRecommendedBankAccount() {
    return myBankAccounts
        .where((account) => account.transferCount > 0)
        .toList();
  }

  List<PayNowRecipient> getPayNowFromContactExcluding(
    List<TransferReceivable> toExclude,
  ) {
    return transferReceivables
        .where((account) => account.isPayNow && !toExclude.contains(account))
        .map((e) => e as PayNowRecipient,)
        .toList();
  }
}
