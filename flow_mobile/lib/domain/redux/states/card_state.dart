import 'package:flow_mobile/domain/entity/card.dart';

class CardState {
  final List<Card> cards;

  CardState({this.cards = const []});

  factory CardState.initial() => CardState(cards: []);

  CardState copyWith({List<Card>? cards}) {
    return CardState(cards: cards ?? this.cards);
  }
}