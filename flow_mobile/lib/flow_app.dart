import 'package:flow_mobile/domain/redux/actions/screen_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flutter/services.dart';
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
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (_navigatorKey.currentState?.canPop() == false) {
            SystemNavigator.pop();
          } else {
            _navigatorKey.currentState?.pop(result);
          }
        },
        child: SizedBox(
          width: screenSize.width,
          height: screenSize.height,
          child: Navigator(
            key: _navigatorKey,
            initialRoute: '/home',
            
          ),
        ),
      ),
    );
  }
}
