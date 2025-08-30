import 'package:flow_mobile/domain/entity/bank.dart';

class InitSelectedBankAction {
  final List<Bank> banks;

  InitSelectedBankAction(this.banks);
}

class SelectBankAction {
  final Bank bank;

  SelectBankAction(this.bank);
}

class CancelLinkBankingScreenAction {
  final Bank bank;
  CancelLinkBankingScreenAction({required this.bank});
}

class StartBankLinkingAction {
  final Bank bank;
  final String linkStartTimestamp;
  StartBankLinkingAction({required this.bank, required this.linkStartTimestamp});
}


class BankLinkingSuccessAction {
  final Bank bank;
  BankLinkingSuccessAction({required this.bank});
}

class RemoveCurrentLinkingBankAction {}
