import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flow_mobile/presentation/providers/state_models/user_state_model.dart';
import 'package:flow_mobile/presentation/providers/state_models/transaction_state_model.dart';
import 'package:flow_mobile/presentation/providers/state_models/bank_account_state_model.dart';
import 'package:flow_mobile/presentation/providers/state_models/transfer_state_model.dart';
import 'package:flow_mobile/presentation/providers/state_models/settings_state_model.dart';
import 'package:flow_mobile/presentation/providers/state_models/notification_state_model.dart';
import 'package:flow_mobile/presentation/providers/state_models/transfer_receivable_state_model.dart';
import 'package:flow_mobile/presentation/providers/state_models/screen_state_model.dart';

part 'app_state_model.freezed.dart';

@freezed
class AppStateModel with _$AppStateModel {
  const factory AppStateModel({
    required UserStateModel userState,
    required TransferStateModel transferState,
    required SettingsStateModel settingsState,
    required ScreenStateModel screenState,
    required BankAccountStateModel bankAccountState,
    required TransactionStateModel transactionState,
    required TransferReceivableStateModel transferReceivableState,
    required NotificationStateModel notificationState,
  }) = _AppStateModel;

  factory AppStateModel.initial() => AppStateModel(
    userState: UserStateModel.initial(),
    transferState: TransferStateModel.initial(),
    settingsState: SettingsStateModel.initial(),
    screenState: ScreenStateModel.initial(),
    bankAccountState: BankAccountStateModel.initial(),
    transactionState: TransactionStateModel.initial(),
    transferReceivableState: TransferReceivableStateModel.initial(),
    notificationState: NotificationStateModel.initial(),
  );
}