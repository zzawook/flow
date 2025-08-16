import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';

/// StateNotifier for the main App state that combines all individual states
class AppStateNotifier extends StateNotifier<AppStateModel> {
  AppStateNotifier() : super(AppStateModel.initial());

  /// Update the entire app state
  void updateAppState(AppStateModel newState) {
    state = newState;
  }

  /// Update user state
  void updateUserState(UserStateModel userState) {
    state = state.copyWith(userState: userState);
  }

  /// Update transaction state
  void updateTransactionState(TransactionStateModel transactionState) {
    state = state.copyWith(transactionState: transactionState);
  }

  /// Update bank account state
  void updateBankAccountState(BankAccountStateModel bankAccountState) {
    state = state.copyWith(bankAccountState: bankAccountState);
  }

  /// Update transfer state
  void updateTransferState(TransferStateModel transferState) {
    state = state.copyWith(transferState: transferState);
  }

  /// Update settings state
  void updateSettingsState(SettingsStateModel settingsState) {
    state = state.copyWith(settingsState: settingsState);
  }

  /// Update notification state
  void updateNotificationState(NotificationStateModel notificationState) {
    state = state.copyWith(notificationState: notificationState);
  }

  /// Update transfer receivable state
  void updateTransferReceivableState(TransferReceivableStateModel transferReceivableState) {
    state = state.copyWith(transferReceivableState: transferReceivableState);
  }

  /// Update screen state
  void updateScreenState(ScreenStateModel screenState) {
    state = state.copyWith(screenState: screenState);
  }

  /// Reset app state to initial
  void resetAppState() {
    state = AppStateModel.initial();
  }
}

/// Provider for AppStateNotifier
final appStateNotifierProvider = StateNotifierProvider<AppStateNotifier, AppStateModel>((ref) {
  final notifier = AppStateNotifier();
  
  // Listen to individual state changes and update the composite app state
  ref.listen(userNotifierProvider, (previous, next) {
    notifier.updateUserState(next);
  });
  
  ref.listen(transactionNotifierProvider, (previous, next) {
    notifier.updateTransactionState(next);
  });
  
  ref.listen(bankAccountNotifierProvider, (previous, next) {
    notifier.updateBankAccountState(next);
  });
  
  ref.listen(transferNotifierProvider, (previous, next) {
    notifier.updateTransferState(next);
  });
  
  ref.listen(settingsNotifierProvider, (previous, next) {
    notifier.updateSettingsState(next);
  });
  
  ref.listen(notificationNotifierProvider, (previous, next) {
    notifier.updateNotificationState(next);
  });
  
  ref.listen(transferReceivableNotifierProvider, (previous, next) {
    notifier.updateTransferReceivableState(next);
  });
  
  ref.listen(screenNotifierProvider, (previous, next) {
    notifier.updateScreenState(next);
  });
  
  return notifier;
});

/// Convenience provider for accessing the complete app state
final appStateProvider = Provider<AppStateModel>((ref) {
  return ref.watch(appStateNotifierProvider);
});

/// Convenience providers for accessing individual states from the composite app state
final appUserStateProvider = Provider<UserStateModel>((ref) {
  return ref.watch(appStateNotifierProvider).userState;
});

final appTransactionStateProvider = Provider<TransactionStateModel>((ref) {
  return ref.watch(appStateNotifierProvider).transactionState;
});

final appBankAccountStateProvider = Provider<BankAccountStateModel>((ref) {
  return ref.watch(appStateNotifierProvider).bankAccountState;
});

final appTransferStateProvider = Provider<TransferStateModel>((ref) {
  return ref.watch(appStateNotifierProvider).transferState;
});

final appSettingsStateProvider = Provider<SettingsStateModel>((ref) {
  return ref.watch(appStateNotifierProvider).settingsState;
});

final appNotificationStateProvider = Provider<NotificationStateModel>((ref) {
  return ref.watch(appStateNotifierProvider).notificationState;
});

final appTransferReceivableStateProvider = Provider<TransferReceivableStateModel>((ref) {
  return ref.watch(appStateNotifierProvider).transferReceivableState;
});

final appScreenStateProvider = Provider<ScreenStateModel>((ref) {
  return ref.watch(appStateNotifierProvider).screenState;
});