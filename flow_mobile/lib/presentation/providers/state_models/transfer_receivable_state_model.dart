import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flow_mobile/domain/entities/entities.dart';

part 'transfer_receivable_state_model.freezed.dart';

@freezed
class TransferReceivableStateModel with _$TransferReceivableStateModel {
  const factory TransferReceivableStateModel({
    @Default([]) List<TransferReceivable> transferReceivables,
    @Default([]) List<BankAccount> myBankAccounts,
  }) = _TransferReceivableStateModel;

  factory TransferReceivableStateModel.initial() => const TransferReceivableStateModel();
}

// Extension methods to mirror the existing Redux state functionality
extension TransferReceivableStateModelExtensions on TransferReceivableStateModel {
  List<PayNowRecipient> getRecommendedPayNow() {
    return transferReceivables
        .where((account) => account.isPayNow && account.transferCount > 0)
        .map((e) => e as PayNowRecipient)
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
        .map((e) => e as PayNowRecipient)
        .toList();
  }
}