import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/reducers/bank_account_reducer.dart';
import 'package:flow_mobile/domain/redux/reducers/screen_reducer.dart';
import 'package:flow_mobile/domain/redux/reducers/setting_reducer.dart';
import 'package:flow_mobile/domain/redux/reducers/transaction_reducer.dart';
import 'package:flow_mobile/domain/redux/reducers/transfer_reducer.dart';
import 'package:flow_mobile/domain/redux/reducers/user_reducer.dart';

FlowState flowReducer(FlowState state, dynamic action) {
  return FlowState(
    userState: userReducer(state.userState, action),
    transferState: transferReducer(state.transferState, action),
    settingsState: settingsReducer(state.settingsState, action),
    screenState: screenReducer(state.screenState, action),
    bankAccountState: bankAccountReducer(state.bankAccountState, action),
    transactionState: transactionReducer(state.transactionState, action),
  );
}