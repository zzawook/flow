import 'package:flow_mobile/domain/entity/card.dart';
import 'package:flow_mobile/domain/redux/states/card_state.dart';

class ClearCardStateAction {}

class SetCardStateAction {
  final CardState cardState;

  SetCardStateAction(this.cardState);
}

class AddCardAction {
  final List<Card> cards;

  AddCardAction(this.cards);
}

class RemoveCardAction {
  final Card card;

  RemoveCardAction(this.card);
}

class UpdateCardAction {
  final Card card;

  UpdateCardAction(this.card);
}
