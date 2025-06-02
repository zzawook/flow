import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class FlowBottomNavBar extends StatefulWidget {
  const FlowBottomNavBar({super.key});

  @override
  State<FlowBottomNavBar> createState() => _FlowBottomNavBarState();
}

class _FlowBottomNavBarState extends State<FlowBottomNavBar> {
  @override
  Widget build(BuildContext context) {
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
      child: StoreConnector<FlowState, String>(
        converter: (store) => store.state.screenState.screenName,
        builder: (context, screenName) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: navItem("home", "Home", screenName == '/home', () {
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
                child: navItem(
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
                child: navItem("asset", "Asset", screenName == '/asset', () {
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
                child: navItem(
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
                child: navItem(
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
          );
        },
      ),
    );
  }

  Widget navItem(String icon, String title, bool isSelected, Function() onTap) {
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
