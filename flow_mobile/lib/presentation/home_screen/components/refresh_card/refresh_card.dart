import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/service/navigation_service.dart';
import 'package:flutter/material.dart';

/// A placeholder section for a "Quick Transfer" feature.
class RefreshCard extends StatelessWidget {
  const RefreshCard({super.key});

  void onQuickTransferPressed(BuildContext context) {
    final navigationService = getIt<NavigationService>();
    navigationService.pushNamed(
      AppRoutes.refresh,
      arguments: CustomPageRouteArguments(
        transitionType: TransitionType.slideTop,
      ),
    );
  }

  static const double _horizontalPadding = 24.0;
  static const double _verticalPadding = 20.0;
  static const double _bottomMargin = 15.0;
  static const double _borderRadius = 15.0;
  static const double _iconSize = 30.0;

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
                'Refresh data',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Icon(
              Icons.refresh,
              size: _iconSize,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 150),
            ),
          ],
        ),
      ),
    );
  }
}
