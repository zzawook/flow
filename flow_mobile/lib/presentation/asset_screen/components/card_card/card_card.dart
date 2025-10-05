import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/entity/card.dart' as BankCard;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CardCard extends StatelessWidget {
  const CardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<FlowState, List<BankCard.Card>>(
      converter: (store) => store.state.cardState.cards,
      builder: (context, cards) {
        if (cards.isEmpty) {
          return const SizedBox.shrink();
        }
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cards",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),

                    ...cards.map(
                      (card) =>
                          _CardRow(listIndex: cards.indexOf(card), card: card),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CardRow extends StatelessWidget {
  const _CardRow({required this.listIndex, required this.card});

  final int listIndex;
  final BankCard.Card card;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // ── account info
          Expanded(
            child: SizedBox(
              height: 50,
              child: Row(
                children: [
                  // ── bank logo
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: onSurface.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.account_balance),
                  ),
                  const SizedBox(width: 20),

                  // ── account name & balance
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.cardName,
                          style: TextStyle(color: onSurface.withAlpha(180)),
                        ),
                        Text(
                          '\$ ${card.balance}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
