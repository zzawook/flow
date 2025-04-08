import 'package:flow_mobile/domain/redux/actions/transfer_actions.dart';
import 'package:flow_mobile/domain/redux/states/transfer_state.dart';

TransferState transferReducer(TransferState state, dynamic action) {
  if (action is SelectFromBankAccountAction) {
    return TransferState(
      fromAccount: action.bankAccount,
      toAccount: state.toAccount,
      amount: state.amount,
      remarks: state.remarks,
      network: state.network,
    );
  }
  if (action is SelectFromBankAccountAction) {
    return TransferState(
      fromAccount: action.bankAccount,
      toAccount: state.toAccount,
      amount: state.amount,
      remarks: state.remarks,
      network: state.network,
    );
  }
  if (action is SelectNetworkAction) {
    return TransferState(
      fromAccount: state.fromAccount,
      toAccount: state.toAccount,
      amount: state.amount,
      remarks: state.remarks,
      network: action.network,
    );
  }
  if (action is EnterAmountAction) {
    return TransferState(
      fromAccount: state.fromAccount,
      toAccount: state.toAccount,
      amount: action.amount,
      remarks: state.remarks,
      network: state.network,
    );
  }
  if (action is CustomizeRemarksAction) {
    return TransferState(
      fromAccount: state.fromAccount,
      toAccount: state.toAccount,
      amount: state.amount,
      remarks: action.remarks,
      network: state.network,
    );
  }
  if (action is CancelTransferAction) {
    return TransferState.initial();
  }
  return state;
}
