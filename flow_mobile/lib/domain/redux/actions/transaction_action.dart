import 'package:flow_mobile/domain/redux/states/transaction_state.dart';

class SetTransactionStateAction {
  final TransactionState transactionHistoryState;

  SetTransactionStateAction({required this.transactionHistoryState});
}

class ClearTransactionStateAction {}