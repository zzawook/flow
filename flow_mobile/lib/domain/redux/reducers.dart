import 'package:flow_mobile/domain/redux/app_state.dart';
import 'package:flow_mobile/domain/redux/reducers/screen_reducer.dart';
import 'package:flow_mobile/domain/redux/reducers/setting_reducer.dart';
import 'package:flow_mobile/domain/redux/reducers/transaction_reducer.dart';
import 'package:flow_mobile/domain/redux/reducers/user_reducer.dart';

FlowState flowReducer(FlowState state, dynamic action) {
  return FlowState(
    userState: userReducer(state.userState, action),
    transactionState: transactionReducer(state.transactionState, action),
    settingsState: settingsReducer(state.settingsState, action),
    screenState: screenReducer(state.screenState, action)
  );
}