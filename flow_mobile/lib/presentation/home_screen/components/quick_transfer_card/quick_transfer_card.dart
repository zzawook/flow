import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flutter/material.dart';

/// A placeholder section for a "Quick Transfer" feature.
class QuickTransferCard extends StatelessWidget {
  const QuickTransferCard({super.key});

  void onQuickTransferPressed(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/transfer',
      arguments: CustomPageRouteArguments(
        transitionType: TransitionType.slideLeft,
      ),
    );
  }

  static const double _horizontalPadding = 24.0;
  static const double _verticalPadding = 25.0;
  static const double _bottomMargin = 15.0;
  static const double _borderRadius = 15.0;
  static const double _iconSize = 17.0;

  @override
  Widget build(BuildContext context) {
    return FlowButton(
      onPressed: () {
        onQuickTransferPressed(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: _verticalPadding,
          horizontal: _horizontalPadding,
        ),
        margin: EdgeInsets.only(bottom: _bottomMargin),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Quick transfer',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Image.asset(
              'assets/icons/arrow_right.png',
              width: _iconSize,
              height: _iconSize,
            ),
          ],
        ),
      ),
    );
  }
}
