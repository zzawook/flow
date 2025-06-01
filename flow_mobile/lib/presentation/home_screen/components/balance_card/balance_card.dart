import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flutter/material.dart';

import 'balance_detail.dart';

class BalanceCard extends StatelessWidget {
  final bool isOnHomeScreen;

  const BalanceCard({super.key, required this.isOnHomeScreen});

  static const _horizontalPadding = 24.0;
  static const _verticalPadding = 24.0;
  static const _borderRadius = 15.0;

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      padding: const EdgeInsets.only(
        top: _verticalPadding,
        left: _horizontalPadding,
        right: _horizontalPadding,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _BalanceCardTitle(),
          const _AsOfDateText(),
          if (!isOnHomeScreen) const SizedBox(height: 16),
          BalanceDetail(isOnHomeScreen: isOnHomeScreen),
          if (isOnHomeScreen)
            const _FindOutMore()
          else
            const SizedBox(height: 30),
        ],
      ),
    );

    if (isOnHomeScreen) {
      return FlowButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/spending',
            arguments: CustomPageRouteArguments(
              transitionType: TransitionType.slideLeft,
            ),
          );
        },
        child: cardContent,
      );
    }
    return cardContent;
  }
}

class _BalanceCardTitle extends StatelessWidget {
  const _BalanceCardTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Text(
        "This Month's Balance",
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _AsOfDateText extends StatelessWidget {
  const _AsOfDateText();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 25),
      child: Text(
        'As of today',
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}

class _FindOutMore extends StatelessWidget {
  const _FindOutMore();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/spending',
          arguments: CustomPageRouteArguments(
            transitionType: TransitionType.slideLeft,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Find out more',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                color: Color(0xFFA6A6A6),
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 12, color: Color(0xFFA19F9F)),
          ],
        ),
      ),
    );
  }
}
