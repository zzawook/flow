import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// GoRouter observer to track navigation events
/// This replaces the Redux route observer functionality
class GoRouterObserver extends NavigatorObserver {
  final WidgetRef ref;
  
  GoRouterObserver(this.ref);

  void _notify(Route<dynamic>? route) {
    final name = route?.settings.name;
    if (name != null) {
      // TODO: Replace with Riverpod navigation tracking when Redux is removed
      // For now, this maintains the same interface but doesn't dispatch Redux actions
      // ref.read(navigationProvider.notifier).navigateToScreen(name);
      debugPrint('Navigation: $name');
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