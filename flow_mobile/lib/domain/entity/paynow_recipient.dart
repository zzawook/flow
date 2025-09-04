import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/entity/transfer_receivable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'paynow_recipient.g.dart';

@HiveType(typeId: 7)
class PayNowRecipient implements TransferReceivable {
  @override
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String phoneNumber;

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
    required this.phoneNumber,
    required this.idNumber,
    required this.bank,
    required this.transferCount,
  });

  PayNowRecipient copyWith({
    String? name,
    String? phoneNumber,
    String? idNumber,
    Bank? bank,
    int? transferCount
  }) {
    return PayNowRecipient(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      idNumber: idNumber ?? this.idNumber,
      bank: bank ?? this.bank,
      transferCount: transferCount ?? this.transferCount,
    );
  }

  PayNowRecipient initial() => PayNowRecipient(
    name: '',
    phoneNumber: '',
    idNumber: '',
    bank: Bank.initial(),
    transferCount: 0
  );

  @override
  String get identifier {
    return phoneNumber;
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
