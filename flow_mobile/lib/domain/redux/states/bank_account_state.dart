import 'package:flow_mobile/domain/entity/bank_account.dart';

class BankAccountState {
  final bool isLoading;
  final List<BankAccount> bankAccounts;
  final String error;

  BankAccountState({
    this.isLoading = false,
    this.bankAccounts = const [],
    this.error = '',
  });

  BankAccountState copyWith({
    bool? isLoading,
    List<BankAccount>? bankAccounts,
    String? error,
  }) {
    return BankAccountState(
      isLoading: isLoading ?? this.isLoading,
      bankAccounts: bankAccounts ?? this.bankAccounts,
      error: error ?? this.error,
    );
  }

  factory BankAccountState.initial() => BankAccountState();
}
