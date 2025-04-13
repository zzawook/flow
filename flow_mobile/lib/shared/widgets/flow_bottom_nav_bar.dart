import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class FlowBottomNavBar extends StatefulWidget {

  const FlowBottomNavBar({
    super.key,
  });

  @override
  State<FlowBottomNavBar> createState() => _FlowBottomNavBarState();
}

class _FlowBottomNavBarState extends State<FlowBottomNavBar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF5F5F5),
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Color(0xFFEEEEEE),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: StoreConnector<FlowState, String>(
          converter: (store) => store.state.screenState.screenName,
          builder: (context, screenName) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: navItem("home", screenName == '/home', () {
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
                  child: navItem("spending", screenName == '/spending', () {
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
                  child: navItem("analysis", screenName == '/transfer', () {
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
              ],
            );
          },
        ),
      ),
    );
  }

  Widget navItem(String icon, bool isSelected, Function() onTap) {
    return FlowButton(
      onPressed: () => onTap(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Image.asset(
          'assets/icons/${icon}_icon.png',
          height: 30,
          width: 30,
          color: isSelected ? Color(0xFF000000) : Color(0xFFBDBDBD),
        ),
      ),
    );
  }
}
