import 'package:flow_mobile/domain/entity/bank.dart';

class LinkBankScreenArgument {
  final Bank bank;
  final String linkUrl;

  LinkBankScreenArgument({required this.bank, required this.linkUrl});
}
