import 'package:flow_mobile/domain/redux/states/screen_state.dart';
import 'package:flow_mobile/domain/redux/states/setting_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
import 'package:flow_mobile/domain/redux/states/user_state.dart';

class FlowState {
  final UserState userState;
  final TransactionState transactionState;
  final SettingsState settingsState;
  final ScreenState screenState;
  FlowState({
    required this.userState,
    required this.transactionState,
    required this.settingsState,
    required this.screenState,
  });

  factory FlowState.initial() => FlowState(
    userState: UserState.initial(),
    transactionState: TransactionState.initial(),
    settingsState: SettingsState.initial(),
    screenState: ScreenState.initial(),
  );
}
