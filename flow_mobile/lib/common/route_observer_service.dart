import 'package:flutter/widgets.dart';

class RouteObserverService extends NavigatorObserver {
  String? currentRouteName;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print(route.settings.name);
    currentRouteName = route.settings.name;
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    print(newRoute?.settings.name);
    currentRouteName = newRoute?.settings.name;
  }
}
