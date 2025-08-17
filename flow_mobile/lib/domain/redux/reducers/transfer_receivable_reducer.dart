import 'package:flow_mobile/domain/redux/actions/user_actions.dart';
import 'package:flow_mobile/domain/redux/states/transfer_receivable_state.dart';

TransferReceivableState transferReceivableReducer(
  TransferReceivableState state,
  dynamic action,
) {
  if (action is DeleteUserAction) {
    return TransferReceivableState.initial();
  }
  return state;
}
