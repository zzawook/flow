import 'package:flow_mobile/domain/entities/bank.dart';

class InitSelectedBankAction {
  final List<Bank> banks;

  InitSelectedBankAction(this.banks);
}

class SelectBankAction {
  final Bank bank;

  SelectBankAction(this.bank);
}