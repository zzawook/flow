import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/presentation/providers/state_models/state_models.dart';
import 'package:flow_mobile/domain/entities/entities.dart';

/// StateNotifier for Transfer state management
class TransferNotifier extends StateNotifier<TransferStateModel> {
  TransferNotifier() : super(TransferStateModel.initial());

  /// Set from account
  void setFromAccount(BankAccount account) {
    state = state.copyWith(fromAccount: account);
  }

  /// Select from bank account (alias for setFromAccount for compatibility)
  void selectFromBankAccount(BankAccount account) {
    setFromAccount(account);
  }

  /// Set receiving account/recipient
  void setReceiving(TransferReceivable receiving) {
    state = state.copyWith(receiving: receiving);
  }

  /// Set transfer amount
  void setAmount(int amount) {
    state = state.copyWith(amount: amount);
  }

  /// Set transfer remarks
  void setRemarks(String remarks) {
    state = state.copyWith(remarks: remarks);
  }

  /// Set transfer network
  void setNetwork(String network) {
    state = state.copyWith(network: network);
  }

  /// Reset transfer state
  void resetTransfer() {
    state = TransferStateModel.initial();
  }

  /// Clear transfer data but keep accounts
  void clearTransferData() {
    state = state.copyWith(
      amount: 0,
      remarks: '',
      network: 'PAYNOW',
    );
  }
}

/// StateNotifier for TransferReceivable state management
class TransferReceivableNotifier extends StateNotifier<TransferReceivableStateModel> {
  TransferReceivableNotifier() : super(TransferReceivableStateModel.initial());

  /// Set transfer receivables
  void setTransferReceivables(List<TransferReceivable> receivables) {
    state = state.copyWith(transferReceivables: receivables);
  }

  /// Add transfer receivable
  void addTransferReceivable(TransferReceivable receivable) {
    final updatedReceivables = [...state.transferReceivables, receivable];
    state = state.copyWith(transferReceivables: updatedReceivables);
  }

  /// Remove transfer receivable
  void removeTransferReceivable(TransferReceivable receivable) {
    final updatedReceivables = state.transferReceivables
        .where((r) => r != receivable)
        .toList();
    state = state.copyWith(transferReceivables: updatedReceivables);
  }

  /// Set my bank accounts
  void setMyBankAccounts(List<BankAccount> accounts) {
    state = state.copyWith(myBankAccounts: accounts);
  }

  /// Add my bank account
  void addMyBankAccount(BankAccount account) {
    final updatedAccounts = [...state.myBankAccounts, account];
    state = state.copyWith(myBankAccounts: updatedAccounts);
  }

  /// Remove my bank account
  void removeMyBankAccount(BankAccount account) {
    final updatedAccounts = state.myBankAccounts
        .where((a) => a != account)
        .toList();
    state = state.copyWith(myBankAccounts: updatedAccounts);
  }

  /// Clear all data
  void clearAll() {
    state = TransferReceivableStateModel.initial();
  }
}

/// Provider for TransferNotifier
final transferNotifierProvider = StateNotifierProvider<TransferNotifier, TransferStateModel>((ref) {
  return TransferNotifier();
});

/// Provider for TransferReceivableNotifier
final transferReceivableNotifierProvider = StateNotifierProvider<TransferReceivableNotifier, TransferReceivableStateModel>((ref) {
  return TransferReceivableNotifier();
});

/// Convenience providers for accessing transfer states
final transferStateProvider = Provider<TransferStateModel>((ref) {
  return ref.watch(transferNotifierProvider);
});

final transferReceivableStateProvider = Provider<TransferReceivableStateModel>((ref) {
  return ref.watch(transferReceivableNotifierProvider);
});

/// Convenience providers for specific transfer data
final transferFromAccountProvider = Provider<BankAccount>((ref) {
  return ref.watch(transferNotifierProvider).fromAccount;
});

final transferReceivingProvider = Provider<TransferReceivable>((ref) {
  return ref.watch(transferNotifierProvider).receiving;
});

final transferAmountProvider = Provider<int>((ref) {
  return ref.watch(transferNotifierProvider).amount;
});

final transferRemarksProvider = Provider<String>((ref) {
  return ref.watch(transferNotifierProvider).remarks;
});

final transferNetworkProvider = Provider<String>((ref) {
  return ref.watch(transferNotifierProvider).network;
});

/// Convenience providers for transfer receivables
final recommendedPayNowProvider = Provider<List<PayNowRecipient>>((ref) {
  return ref.watch(transferReceivableNotifierProvider).getRecommendedPayNow();
});

final recommendedBankAccountProvider = Provider<List<BankAccount>>((ref) {
  return ref.watch(transferReceivableNotifierProvider).getRecommendedBankAccount();
});