import 'package:flow_mobile/domain/entity/bank_account.dart';
import 'package:flow_mobile/domain/redux/states/bank_account_state.dart';

class SetBankAccountStateAction {
  BankAccountState bankAccountState;

  SetBankAccountStateAction({required this.bankAccountState});
}

class SetBankAccountNameAction {
  final BankAccount bankAccount;
  final String newName;

  SetBankAccountNameAction({required this.bankAccount, required this.newName});
}

class ToggleBankAccountHiddenAction {
  final BankAccount bankAccount;

  ToggleBankAccountHiddenAction({required this.bankAccount});
}

class ClearBankAccountStateAction {}

class UpdateAccountOrderAction {
  final BankAccount bankAccount;
  final int newIndex;
  final int oldIndex;

  UpdateAccountOrderAction({
    required this.bankAccount,
    required this.newIndex,
    required this.oldIndex,
  });
}
