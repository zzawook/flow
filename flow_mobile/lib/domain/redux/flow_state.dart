import 'package:flow_mobile/domain/redux/states/auth_state.dart';
import 'package:flow_mobile/domain/redux/states/bank_account_state.dart';
import 'package:flow_mobile/domain/redux/states/card_state.dart';
import 'package:flow_mobile/domain/redux/states/notification_state.dart';
import 'package:flow_mobile/domain/redux/states/screen_state.dart';
import 'package:flow_mobile/domain/redux/states/setting_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
import 'package:flow_mobile/domain/redux/states/transfer_receivable_state.dart';
import 'package:flow_mobile/domain/redux/states/transfer_state.dart';
import 'package:flow_mobile/domain/redux/states/user_state.dart';

class FlowState {
  final UserState userState;
  final TransferState transferState;
  final SettingsState settingsState;
  final ScreenState screenState;
  final BankAccountState bankAccountState;
  final CardState cardState;
  final TransactionState transactionState;
  final TransferReceivableState transferReceivableState;
  final NotificationState notificationState;
  final AuthState authState;

  FlowState({
    required this.userState,
    required this.transferState,
    required this.settingsState,
    required this.screenState,
    required this.bankAccountState,
    required this.cardState,
    required this.transactionState,
    required this.transferReceivableState,
    required this.notificationState,
    required this.authState
  });

  factory FlowState.initial() => FlowState(
    userState: UserState.initial(),
    transferState: TransferState.initial(),
    settingsState: SettingsState.initial(),
    screenState: ScreenState.initial(),
    bankAccountState: BankAccountState.initial(),
    cardState: CardState.initial(),
    transactionState: TransactionState.initial(),
    transferReceivableState: TransferReceivableState.initial(),
    notificationState: NotificationState.initial(),
    authState: AuthState.initial(),
  );
}
