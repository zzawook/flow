import 'package:flow_mobile/common/flow_bottom_nav_bar.dart';
import 'package:flow_mobile/domain/redux/actions/screen_actions.dart';
import 'package:flow_mobile/domain/redux/app_state.dart';
import 'package:flow_mobile/presentation/home_screen/flow_home_screen.dart';
import 'package:flow_mobile/presentation/spending_screen/spending_screen.dart';
import 'package:flow_mobile/presentation/trsansfer_screen/transfer_amount_screen.dart';
import 'package:flow_mobile/presentation/trsansfer_screen/transfer_screen.dart';
import 'package:flow_mobile/presentation/trsansfer_screen/transfer_to_screen.dart';
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
    _navigatorKey.currentState!.pushNamed(routeName);
  }

  void updateScreenState(String screenName) {
    StoreProvider.of<FlowState>(
      context,
    ).dispatch(NavigateToScreenAction(screenName));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ScreenTopMargin(),
        Expanded(
          child: Navigator(
            key: _navigatorKey,
            initialRoute: '/home',
            onDidRemovePage:
                (page) => {
                  StoreProvider.of<FlowState>(
                    context,
                  ).dispatch(NavigateToPreviousScreenAction()),
                },
            onGenerateRoute: (RouteSettings settings) {
              Widget page;
              updateScreenState(settings.name?.toString() ?? "/home");
              switch (settings.name) {
                case '/home':
                  page = FlowHomeScreen();
                  break;
                case '/spending':
                  page = SpendingScreen();
                  break;
                case '/transfer':
                  page = TransferScreen();
                  break;
                case '/transfer/amount':
                  page = TransferAmountScreen();
                  break;
                case '/transfer/to':
                  page = TransferToScreen();
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

class ScreenTopMargin extends StatelessWidget {
  const ScreenTopMargin({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 32);
  }
}
