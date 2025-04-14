import 'package:flow_mobile/domain/redux/actions/screen_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/home_screen/flow_home_screen.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/notification/notification_screen.dart';
import 'package:flow_mobile/presentation/refresh_screen/refresh_init_screen.dart';
import 'package:flow_mobile/presentation/spending_detail_screen/spending_detail_screen.dart';
import 'package:flow_mobile/presentation/spending_graph_screen/pie_chart_screen.dart';
import 'package:flow_mobile/presentation/spending_screen/spending_screen.dart';
import 'package:flow_mobile/presentation/transfer_screen/transfer_amount_screen.dart';
import 'package:flow_mobile/presentation/transfer_screen/transfer_confirm.dart';
import 'package:flow_mobile/presentation/transfer_screen/transfer_result_screen.dart';
import 'package:flow_mobile/presentation/transfer_screen/transfer_screen.dart';
import 'package:flow_mobile/presentation/transfer_screen/transfer_to_screen/transfer_to_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class FlowApp extends StatefulWidget {
  const FlowApp({super.key});

  @override
  FlowAppState createState() => FlowAppState();
}

class FlowAppState extends State<FlowApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  void updateScreenState(String screenName) {
    StoreProvider.of<FlowState>(
      context,
    ).dispatch(NavigateToScreenAction(screenName));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return DefaultTextStyle(
      style: const TextStyle(fontFamily: 'Inter', color: Color(0xFF000000)),
      child: SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: Navigator(
          key: _navigatorKey,
          initialRoute: '/home',
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
              case '/spending/detail':
                page = SpendingDetailScreen();
                break;
              case '/spending/graph':
                page = PieChartScreen();
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
              case '/transfer/confirm':
                page = TransferConfirmationScreen();
                break;
              case '/transfer/result':
                page = TransferResultScreen();
                break;
              case '/notification':
                page = NotificationScreen();
                break;
              case '/refresh':
                page = RefreshInitScreen();
                break;
              default:
                page = FlowHomeScreen();
            }

            // Read the custom arguments if any.
            final args = settings.arguments as CustomPageRouteArguments?;
            // Use a default transition if none is passed.
            final transition = args?.transitionType ?? TransitionType.slideLeft;

            return PageRouteBuilder(
              settings: settings,
              transitionDuration: Duration(milliseconds: 150),
              pageBuilder: (context, animation, secondaryAnimation) => page,
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                // Choose the transition effect based on the argument.
                switch (transition) {
                  case TransitionType.slideLeft:
                    // Slide in from the right side (moves leftward to center)
                    final tween = Tween(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeInOut));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  case TransitionType.slideRight:
                    // Slide in from the left side (moves rightward to center)
                    final tween = Tween(
                      begin: const Offset(-1.0, 0.0),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeInOut));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  case TransitionType.slideTop:
                    // Slide in from the top (moves downward to center)
                    final tween = Tween(
                      begin: const Offset(0.0, -1.0),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeInOut));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  case TransitionType.slideBottom:
                    // Slide in from the bottom (moves upward to center)
                    final tween = Tween(
                      begin: const Offset(0.0, 1.0),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeInOut));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
