import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/entity/transfer_receivable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'paynow_recipient.g.dart';

@HiveType(typeId: 5)
class PayNowRecipient implements TransferReceivable {
  @override
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String phoneNumer;

  @HiveField(2)
  final String idNumber;

  @override
  @HiveField(3)
  final Bank bank;

  @override
  @HiveField(4)
  final int transferCount;

  PayNowRecipient({
    required this.name,
    required this.phoneNumer,
    required this.idNumber,
    required this.bank,
    required this.transferCount,
  });

  PayNowRecipient copyWith({
    String? name,
    String? phoneNumer,
    String? idNumber,
    Bank? bank,
    int? transferCount
  }) {
    return PayNowRecipient(
      name: name ?? this.name,
      phoneNumer: phoneNumer ?? this.phoneNumer,
      idNumber: idNumber ?? this.idNumber,
      bank: bank ?? this.bank,
      transferCount: transferCount ?? this.transferCount,
    );
  }

  PayNowRecipient initial() => PayNowRecipient(
    name: '',
    phoneNumer: '',
    idNumber: '',
    bank: Bank.initial(),
    transferCount: 0
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
