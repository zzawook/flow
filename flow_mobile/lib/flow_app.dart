import 'package:flow_mobile/common/flow_bottom_nav_bar.dart';
import 'package:flow_mobile/common/route_observer_service.dart';
import 'package:flow_mobile/screens/home_screen/flow_home_screen.dart';
import 'package:flow_mobile/screens/spending_screen/spending_screen.dart';
import 'package:flutter/widgets.dart';

class FlowApp extends StatefulWidget {
  const FlowApp({super.key});

  @override
  FlowAppState createState() => FlowAppState();
}

class FlowAppState extends State<FlowApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _selectedIndex = 0;

  final List<String> _routes = ['/home', '/spending', '/transaction'];

  void _onTabTapped(int index) {
    _navigatorKey.currentState!.pushReplacementNamed(_routes[index]);
    setState(() {
      _selectedIndex = index;
    });
  }

  final routeObserver = RouteObserverService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Navigator(
            key: _navigatorKey,
            observers: [routeObserver],
            initialRoute: '/home',
            onGenerateRoute: (RouteSettings settings) {
              Widget page;
              switch (settings.name) {
                case '/home':
                  page = FlowHomeScreen();
                  break;
                case '/spending':
                  page = SpendingScreen();
                  break;
                case '/transaction':
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
          selectedIndex: _selectedIndex,
          onItemSelected: _onTabTapped,
          routeObserver: routeObserver,
        ),
      ],
    );
  }
}
