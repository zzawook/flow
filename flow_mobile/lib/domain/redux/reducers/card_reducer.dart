import 'package:flow_mobile/domain/entity/card.dart';
import 'package:flow_mobile/domain/redux/actions/card_actions.dart';
import 'package:flow_mobile/domain/redux/states/card_state.dart';

CardState cardReducer(CardState prevState, dynamic action) {
  if (action is ClearCardStateAction) {
    return CardState.initial();
  }
  if (action is SetCardStateAction) {
    return action.cardState;
  }
  if (action is AddCardAction) {
    List<Card> updatedCards = List.from(prevState.cards)
      ..addAll(
        action.cards.where(
          (newCard) => !prevState.cards
              .any((existingCard) => existingCard.cardNumber == newCard.cardNumber),
        ),
      );

    // Update existing cards
    for (var newCard in action.cards) {
      int index = updatedCards.indexWhere((c) => c.cardNumber == newCard.cardNumber);
      if (index != -1) {
        updatedCards[index] = newCard;
      }
    }
    return prevState.copyWith(cards: updatedCards);
  }
  if (action is RemoveCardAction) {
    List<Card> updatedCards = prevState.cards
        .where((card) => card.cardNumber != action.card.cardNumber)
        .toList();
    return prevState.copyWith(cards: updatedCards);
  }
  if (action is UpdateCardAction) {
    List<Card> updatedCards = prevState.cards.map((card) {
      if (card.cardNumber == action.card.cardNumber) {
        return action.card;
      }
      return card;
    }).toList();
    return prevState.copyWith(cards: updatedCards);
  }
  return prevState;
}