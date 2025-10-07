import 'dart:developer';

import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/entity/card.dart';
import 'package:flow_mobile/domain/manager/card_manager.dart';
import 'package:flow_mobile/domain/manager/transaction_manager.dart';
import 'package:flow_mobile/generated/common/v1/card.pb.dart' as ProtoCard;
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/service/api_service/api_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../entity/transaction.dart';

class CardManagerImpl implements CardManager {
  final Box<Card> cardBox;

  static CardManagerImpl? _instance;

  CardManagerImpl._(this.cardBox);

  static Future<CardManagerImpl> getInstance() async {
    if (_instance != null) {
      return _instance!;
    }

    final box = await Hive.openBox<Card>('cardsBox');
    _instance = CardManagerImpl._(box);
    return _instance!;
  }

  @override
  Future<void> clearCards() async {
    await cardBox.clear();
  }

  @override
  Future<List<Card>> getCards() async {
    return cardBox.values.toList();
  }

  @override
  Future<Card?> getCard(String cardNumber) async {
    return cardBox.get(cardNumber);
  }

  @override
  Future<void> addCard(Card card) async {
    await cardBox.put(card.cardNumber, card);
  }

  @override
  Future<void> addCards(List<Card> cards) async {
    for (var card in cards) {
      await cardBox.put(card.cardNumber, card);
    }
  }

  @override
  Future<void> removeCard(Card card) async {
    await cardBox.delete(card.cardNumber);
  }

  @override
  Future<void> updateCard(Card card) async {
    await cardBox.put(card.cardNumber, card);
  }

  @override
  Future<void> fetchCardsFromRemote() async {
    ApiService apiService = getIt<ApiService>();
    try {
      final remoteCardResponse = await apiService.fetchCards();
      print('Fetched ${remoteCardResponse.cards.length} cards from remote');
      for (var protoCard in remoteCardResponse.cards) {
        final card = fromProtoCard(protoCard);
        print("Adding card: ${card.cardNumber}, ${card.cardName}");
        await addCard(card);
      }
    } catch (e) {
      // Handle error appropriately, e.g., logging
      log('Error fetching cards from remote: $e');
    }
  }

  @override
  Future<List<Transaction>> fetchTransactionForCardFromRemote(
    Card card,
    int limit, {
    String? oldestTransactionId,
  }) {
    ApiService apiService = getIt<ApiService>();
    return apiService
        .fetchCardTransactions(
          card,
          limit,
          oldestTransactionId: oldestTransactionId,
        )
        .then((response) async {
          TransactionManager transactionManager = getIt<TransactionManager>();
          List<Transaction> fetchedTransactions = await transactionManager
              .getTransactionForCard(card, limit);

          return fetchedTransactions;
        })
        .catchError((error) {
          log("Error fetching transaction for card: ${card.cardNumber}");
          return List<Transaction>.empty();
        });
  }

  Card fromProtoCard(ProtoCard.Card protoCard) {
    return Card(
      cardNumber: protoCard.cardNumber,
      cardName: protoCard.cardName,
      cardType: protoCard.cardType.name,
      bank: Bank(bankId: protoCard.bank.id, name: protoCard.bank.name),
      balance: protoCard.balance,
    );
  }

  // @override
  // Future<void> fetchCardDetailFromRemote({
  //   required String cardId,
  //   String? oldestTransactionId,
  //   int limit = 20,
  // }) async {
  //   // Implementation for fetching card details from remote
  // }
}
