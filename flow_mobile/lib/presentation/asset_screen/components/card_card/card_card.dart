import 'package:flow_mobile/domain/entity/card.dart' as BankCard;
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/initialization/manager_registry.dart';
import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/service/logo_service.dart';
import 'package:flow_mobile/service/navigation_service.dart';
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
          margin: const EdgeInsets.only(top: 16),
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
                    Text(
                      '\$ ${(cards.fold<double>(0, (sum, card) => sum + card.balance)).toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    ...cards.map(
                      (card) =>
                          _CardRow(listIndex: cards.indexOf(card), card: card),
                    ),

                    const SizedBox(height: 12),
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

    final logoService = getIt<LogoService>();

    return FlowButton(
      onPressed: () {
        final navigationService = getIt<NavigationService>();
        navigationService.pushNamed(
          AppRoutes.cardDetail,
          arguments: CustomPageRouteArguments(
            transitionType: TransitionType.slideLeft,
            extraData: card,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 14),
        child: Row(
          children: [
            // ── account info
            Expanded(
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    // ── bank logo
                    Image.asset(logoService.getBankLogoUri(card.bank)),
                    const SizedBox(width: 20),

                    // ── account name & balance
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            card.cardName,
                            style: TextStyle(color: onSurface.withAlpha(180)),
                          ),
                          if (card.cardType == "CREDIT")
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Icon(
                    Icons.chevron_right,
                    size: 24,
                    color: onSurface.withValues(alpha: 150),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
