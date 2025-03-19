import 'package:flow_mobile/common/flow_bottom_nav_bar.dart';
import 'package:flow_mobile/domain/redux/actions/screen_actions.dart';
import 'package:flow_mobile/domain/redux/app_state.dart';
import 'package:flow_mobile/presentation/home_screen/flow_home_screen.dart';
import 'package:flow_mobile/presentation/spending_screen/spending_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class FlowApp extends StatefulWidget {
  const FlowApp({super.key});

  @override
  FlowAppState createState() => FlowAppState();
}

class FlowAppState extends State<FlowApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  void _onTabTapped(String routeName) {
    _navigatorKey.currentState!.pushReplacementNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Navigator(
            key: _navigatorKey,
            initialRoute: '/home',
            onGenerateRoute: (RouteSettings settings) {
              Widget page;
              switch (settings.name) {
                case '/home':
                  StoreProvider.of<FlowState>(context).dispatch(NavigateToScreenAction("Home"));
                  page = FlowHomeScreen();
                  break;
                case '/spending':
                  StoreProvider.of<FlowState>(context).dispatch(NavigateToScreenAction("Spending"));
                  page = SpendingScreen();
                  break;
                case '/transaction':
                  StoreProvider.of<FlowState>(context).dispatch(NavigateToScreenAction("Transaction"));
                  page = FlowHomeScreen();
                  break;
                default:
                  page = FlowHomeScreen();
              }
              return PageRouteBuilder(
                settings: settings,
                pageBuilder: (context, animation, secondaryAnimation) => page,
              );
            },
          ), // Display current screen
        ),
        FlowBottomNavBar(
          onItemSelected: _onTabTapped,
        ),
      ],
    );
  }
}
