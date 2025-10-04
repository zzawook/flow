import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'card.g.dart';

@HiveType(typeId: 8)
class Card {
  @HiveField(0)
  final String cardNumber;

  @HiveField(1)
  final String cardName;

  @HiveField(3)
  final String cardType; // e.g., "CREDIT", "DEBIT"

  @HiveField(4)
  final Bank bank;

  @HiveField(5)
  final double balance;

  @HiveField(6)
  bool isHidden;

  Card({
    required this.cardNumber,
    required this.cardName,
    required this.cardType,
    required this.bank,
    this.balance = 0.0,
    this.isHidden = false,
  });

  factory Card.initial() => Card(
    cardNumber: '1234 5678 9012 3456',
    cardName: 'John Doe',
    cardType: 'CREDIT',
    bank: Bank.initial(),
    balance: 0.0,
    isHidden: false,
  );

  Card copyWith({
    String? cardNumber,
    String? cardName,
    String? cardType,
    Bank? bank,
    double? balance,
    bool? isHidden,
  }) {
    return Card(
      cardNumber: cardNumber ?? this.cardNumber,
      cardName: cardName ?? this.cardName,
      cardType: cardType ?? this.cardType,
      bank: bank ?? this.bank,
      balance: balance ?? this.balance,
      isHidden: isHidden ?? this.isHidden,
    );
  }
}
