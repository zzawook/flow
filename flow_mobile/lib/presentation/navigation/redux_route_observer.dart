import 'package:flutter/widgets.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/actions/screen_actions.dart';
import 'package:redux/redux.dart';

class ReduxRouteObserver extends NavigatorObserver {
  final Store<FlowState> store;
  ReduxRouteObserver(this.store);

  void _notify(Route<dynamic>? route) {
    final name = route?.settings.name;
    if (name != null) {
      store.dispatch(NavigateToScreenAction(name));
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _notify(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    // previousRoute is now the active one
    _notify(previousRoute);
  }

  @override
  void didReplace({ Route<dynamic>? newRoute, Route<dynamic>? oldRoute }) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _notify(newRoute);
  }
}
