import 'package:flow_mobile/domain/entity/card.dart';

abstract class CardManager {
  Future<void> clearCards();
  Future<List<Card>> getCards();
  Future<Card?> getCard(String cardNumber);
  Future<void> addCard(Card card);
  Future<void> addCards(List<Card> cards);
  Future<void> removeCard(Card card);
  Future<void> updateCard(Card card);
  Future<void> fetchCardsFromRemote() async {}
  // Future<void> fetchCardDetailFromRemote({
  //   required String cardNumber,
  //   String? oldestTransactionId,
  //   int limit = 20,
  // }) async {}
}
