import 'package:flow_mobile/domain/redux/actions/bank_account_action.dart';
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
  return state;
}
