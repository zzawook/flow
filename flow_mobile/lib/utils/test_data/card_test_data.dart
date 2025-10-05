import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/entity/card.dart' as BankCard;

class CardTestData {
  static List<BankCard.Card> getMultipleCards() {
    return [
      BankCard.Card(
        cardName: "DBS Credit Card",
        cardNumber: "1111-2222-3333-4444",
        cardType: "CREDIT",
        bank: Bank(name: "DBS", bankId: 1),
      ),
      BankCard.Card(
        cardName: "OCBC Debit Card",
        cardNumber: "5555-6666-7777-8888",
        cardType: "DEBIT",
        bank: Bank(name: "OCBC", bankId: 2),
      ),
      BankCard.Card(
        cardName: "UOB Credit Card",
        cardNumber: "9999-0000-1111-2222",
        cardType: "CREDIT",
        bank: Bank(name: "UOB", bankId: 3),
      ),
    ];
  }

  static List<BankCard.Card> getSingleCard() {
    return [
      BankCard.Card(
        cardName: "DBS Credit Card",
        cardNumber: "1111-2222-3333-4444",
        cardType: "CREDIT",
        bank: Bank(name: "DBS", bankId: 1),
      ),
    ];
  }

  static List<BankCard.Card> getNoCards() {
    return [];
  }

  static List<BankCard.Card> getEdgeCases() {
    return [
      BankCard.Card(
        cardName: "",
        cardNumber: "",
        cardType: "",
        bank: Bank(name: "", bankId: 0),
      ),
      BankCard.Card(
        cardName: "A" * 100,
        cardNumber: "9" * 50,
        cardType: "CREDIT",
        bank: Bank(name: "UOB", bankId: 3),
      ),
      BankCard.Card(
        cardName: "DBS Credit Card",
        cardNumber: "1111-2222-3333-4444",
        cardType: "SOMETHINGELSE",
        bank: Bank(name: "DBSORSOMETHING", bankId: 1),
      ),
    ];
  }
}
