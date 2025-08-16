import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlowBottomNavBar extends ConsumerWidget {
  const FlowBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenName = ref.watch(currentScreenProvider);
    
    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor.withAlpha(230),
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: _navItem(context, "home", "Home", screenName == '/home', () {
              // Check if the current screen is already the home screen
              if (screenName == '/home') {
                return;
              }
              Navigator.pushNamed(
                context,
                '/home',
                arguments: CustomPageRouteArguments(
                  transitionType: TransitionType.slideRight,
                ),
              );
            }),
          ),
          Expanded(
            child: _navItem(
              context,
              "spending",
              "Spending",
              screenName == '/spending',
              () {
              // Check if the current screen is already the spending screen
              if (screenName == '/spending') {
                return;
              }
              Navigator.pushNamed(
                context,
                '/spending',
                arguments: CustomPageRouteArguments(
                  transitionType:
                      screenName == '/home'
                          ? TransitionType.slideLeft
                          : TransitionType.slideRight,
                ),
              );
            }),
          ),
          Expanded(
            child: _navItem(context, "asset", "Asset", screenName == '/asset', () {
              // Check if the current screen is already the spending screen
              if (screenName == '/asset') {
                return;
              }
              Navigator.pushNamed(
                context,
                '/asset',
                arguments: CustomPageRouteArguments(
                  transitionType: TransitionType.slideLeft,
                ),
              );
            }),
          ),
          Expanded(
            child: _navItem(
              context,
              "transfer",
              "Transfer",
              screenName == '/transfer',
              () {
              // Check if the current screen is already the transfer screen
              if (screenName == '/transfer') {
                return;
              }
              Navigator.pushNamed(
                context,
                '/transfer',
                arguments: CustomPageRouteArguments(
                  transitionType: TransitionType.slideLeft,
                ),
              );
            }),
          ),
          Expanded(
            child: _navItem(
              context,
              "setting",
              "Setting",
              screenName.contains('setting') ||
                  screenName.contains('manage'),
              () {
                // Check if the current screen is already the transfer screen
                if (screenName == '/setting') {
                  return;
                }
                Navigator.pushNamed(
                  context,
                  '/setting',
                  arguments: CustomPageRouteArguments(
                    transitionType: TransitionType.slideLeft,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, String icon, String title, bool isSelected, Function() onTap) {
    final Color selectedColor = Theme.of(context).colorScheme.onSurface;
    final Color unselectedColor = Theme.of(context).disabledColor;

    return FlowButton(
      onPressed: () => onTap(),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Image.asset(
              'assets/icons/${icon}_icon.png',
              height: 25,
              width: 25,
              color: isSelected ? selectedColor : unselectedColor,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: isSelected ? selectedColor : unselectedColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
