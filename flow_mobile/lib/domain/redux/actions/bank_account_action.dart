import 'package:flow_mobile/domain/entity/bank_account.dart';

class SetBankAccountNameAction {
  final BankAccount bankAccount;
  final String newName;

  SetBankAccountNameAction({required this.bankAccount, required this.newName});
}

class ToggleBankAccountHiddenAction {
  final BankAccount bankAccount;

  ToggleBankAccountHiddenAction({required this.bankAccount});
}

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
