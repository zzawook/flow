import 'package:flow_mobile/domain/entity/bank.dart';

abstract class TransferReceivable {
  String get name;
  Bank get bank;
  bool get isPayNow;
  bool get isAccount;
  String get identifier;
  int get transferCount;
}
