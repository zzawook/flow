import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/presentation/providers/state_models/state_models.dart';
import 'package:flow_mobile/domain/usecases/usecases.dart';
import 'package:flow_mobile/domain/entities/entities.dart';
import 'package:flow_mobile/core/providers/providers.dart';

/// StateNotifier for BankAccount state management
class BankAccountNotifier extends StateNotifier<BankAccountStateModel> {
  final GetAccountsUseCase _getAccountsUseCase;
  final CreateAccountUseCase _createAccountUseCase;
  final UpdateAccountUseCase _updateAccountUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;

  BankAccountNotifier(
    this._getAccountsUseCase,
    this._createAccountUseCase,
    this._updateAccountUseCase,
    this._deleteAccountUseCase,
  ) : super(BankAccountStateModel.initial());

  /// Load all bank accounts
  Future<void> loadBankAccounts() async {
    state = state.copyWith(isLoading: true, error: '');
    try {
      final accounts = await _getAccountsUseCase.execute();
      state = state.copyWith(
        bankAccounts: accounts,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Create a new bank account
  Future<void> createBankAccount(BankAccount account) async {
    state = state.copyWith(isLoading: true, error: '');
    try {
      final newAccount = await _createAccountUseCase.execute(account);
      final updatedAccounts = [...state.bankAccounts, newAccount];
      state = state.copyWith(
        bankAccounts: updatedAccounts,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Update an existing bank account
  Future<void> updateBankAccount(BankAccount account) async {
    state = state.copyWith(isLoading: true, error: '');
    try {
      final updatedAccount = await _updateAccountUseCase.execute(account);
      final updatedAccounts = state.bankAccounts
          .map((a) => a.accountNumber == updatedAccount.accountNumber ? updatedAccount : a)
          .toList();
      state = state.copyWith(
        bankAccounts: updatedAccounts,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Delete a bank account
  Future<void> deleteBankAccount(int accountId) async {
    state = state.copyWith(isLoading: true, error: '');
    try {
      await _deleteAccountUseCase.execute(accountId);
      // Reload accounts to get the updated list
      await loadBankAccounts();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: '');
  }
}

/// Provider for BankAccountNotifier
final bankAccountNotifierProvider = StateNotifierProvider<BankAccountNotifier, BankAccountStateModel>((ref) {
  return BankAccountNotifier(
    ref.read(getAccountsUseCaseProvider).value!,
    ref.read(createAccountUseCaseProvider).value!,
    ref.read(updateAccountUseCaseProvider).value!,
    ref.read(deleteAccountUseCaseProvider).value!,
  );
});

/// Convenience provider for accessing bank account state
final bankAccountStateProvider = Provider<BankAccountStateModel>((ref) {
  return ref.watch(bankAccountNotifierProvider);
});

/// Convenience provider for accessing bank accounts list
final bankAccountsProvider = Provider<List<BankAccount>>((ref) {
  return ref.watch(bankAccountNotifierProvider).bankAccounts;
});

/// Convenience provider for accessing loading state
final bankAccountLoadingProvider = Provider<bool>((ref) {
  return ref.watch(bankAccountNotifierProvider).isLoading;
});

/// Convenience provider for accessing error state
final bankAccountErrorProvider = Provider<String>((ref) {
  return ref.watch(bankAccountNotifierProvider).error;
});