import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/thunks/link_thunks.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/service/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

/// A placeholder section for a "Quick Transfer" feature.
class RefreshCard extends StatelessWidget {
  const RefreshCard({super.key});

  void onQuickTransferPressed(BuildContext context, bool hasBankAccounts) {
    final navigationService = getIt<NavigationService>();
    if (hasBankAccounts) {
      navigationService.pushNamed(
      AppRoutes.refresh,
        arguments: CustomPageRouteArguments(
          transitionType: TransitionType.slideTop,
        ),
      );
    } else {
      StoreProvider.of<FlowState>(
        context,
        listen: false,
      ).dispatch(openAddAccountScreenThunk());
    }
  }

  static const double _horizontalPadding = 24.0;
  static const double _verticalPadding = 20.0;
  static const double _bottomMargin = 15.0;
  static const double _borderRadius = 15.0;
  static const double _iconSize = 28.0;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<FlowState, bool>(
      converter: (store) =>
          store.state.bankAccountState.bankAccounts.isNotEmpty,
      builder: (BuildContext context, bool hasBankAccounts) {
        return FlowButton(
          onPressed: () {
            onQuickTransferPressed(context, hasBankAccounts);
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
                    hasBankAccounts ? 'Refresh data' : 'Link a bank',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Icon(
                  hasBankAccounts ? Icons.refresh : Icons.add,
                  size: _iconSize,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 100),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
