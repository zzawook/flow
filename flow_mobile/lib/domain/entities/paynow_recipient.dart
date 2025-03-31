import 'package:flow_mobile/domain/entities/bank.dart';
import 'package:flow_mobile/domain/entities/transfer_receivable.dart';

class PayNowRecipient implements TransferReceivable{
  @override
  final String name;
  final String phoneNumer;
  final String idNumber;

  @override
  final Bank bank;

  PayNowRecipient({
    required this.name,
    required this.phoneNumer,
    required this.idNumber,
    required this.bank,
  });

  PayNowRecipient copyWith({
    String? name,
    String? phoneNumer,
    String? idNumber,
    Bank? bank,
  }) {
    return PayNowRecipient(
      name: name ?? this.name,
      phoneNumer: phoneNumer ?? this.phoneNumer,
      idNumber: idNumber ?? this.idNumber,
      bank: bank ?? this.bank,
    );
  }

  PayNowRecipient initial() => PayNowRecipient(
    name: '',
    phoneNumer: '',
    idNumber: '',
    bank: Bank.initial(),
  );
  
  @override
  String get identifier {
    return phoneNumer;
  }
  
  @override
  bool get isAccount {
    return false;
  }
  
  @override
  bool get isPayNow {
    return true;
  }
}
