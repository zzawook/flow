import 'package:flow_mobile/domain/entities/bank_account.dart';

class SetBankAccountNameAction {
  final BankAccount bankAccount;
  final String newName;

  SetBankAccountNameAction({required this.bankAccount, required this.newName});
}
