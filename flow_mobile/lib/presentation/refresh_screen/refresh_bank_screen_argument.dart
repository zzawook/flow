import 'package:flow_mobile/domain/entity/bank.dart';

class RefreshBankScreenArgument {
  final String url;
  final Bank bank;

  RefreshBankScreenArgument({
    required this.url,
    required this.bank,
  });
}