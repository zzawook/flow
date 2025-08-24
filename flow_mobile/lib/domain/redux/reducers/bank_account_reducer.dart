import 'package:flow_mobile/domain/entity/bank_account.dart';
import 'package:flow_mobile/domain/redux/actions/bank_account_action.dart';
import 'package:flow_mobile/domain/redux/actions/user_actions.dart';
import 'package:flow_mobile/domain/redux/states/bank_account_state.dart';

BankAccountState bankAccountReducer(BankAccountState state, dynamic action) {
  if (action is SetBankAccountNameAction) {
    return state.copyWith(
      bankAccounts:
          state.bankAccounts.map((bankAccount) {
            if (bankAccount.isEqualTo(action.bankAccount)) {
              return bankAccount.copyWith(accountName: action.newName);
            }
            return bankAccount;
          }).toList(),
    );
  }
  if (action is ToggleBankAccountHiddenAction) {
    return state.copyWith(
      bankAccounts:
          state.bankAccounts.map((bankAccount) {
            if (bankAccount.isEqualTo(action.bankAccount)) {
              return bankAccount.copyWith(isHidden: !bankAccount.isHidden);
            }
            return bankAccount;
          }).toList(),
    );
  }
  if (action is UpdateAccountOrderAction) {
    List<BankAccount> newList = [...state.bankAccounts];

    BankAccount toMove = newList.removeAt(action.oldIndex);
    newList.insert(action.newIndex, toMove);

    return state.copyWith(bankAccounts: newList);
  }
  if (action is SetBankAccountStateAction) {
    return action.bankAccountState;
  }
  if (action is DeleteUserAction || action is ClearBankAccountStateAction) {
    return BankAccountState.initial();
  }
  return state;
}
