import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

/// StateNotifier for Navigation state management
class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(const NavigationState.initial());

  /// Navigate to a specific route
  void navigateTo(String route) {
    state = NavigationState.navigating(route);
  }

  /// Go back to previous route
  void goBack() {
    state = const NavigationState.goingBack();
  }

  /// Reset navigation state
  void resetNavigation() {
    state = const NavigationState.initial();
  }

  /// Set current route
  void setCurrentRoute(String route) {
    state = NavigationState.currentRoute(route);
  }
}

/// Navigation state sealed class
sealed class NavigationState {
  const NavigationState();

  const factory NavigationState.initial() = NavigationInitial;
  const factory NavigationState.navigating(String route) = NavigationNavigating;
  const factory NavigationState.goingBack() = NavigationGoingBack;
  const factory NavigationState.currentRoute(String route) = NavigationCurrentRoute;
}

class NavigationInitial extends NavigationState {
  const NavigationInitial();
}

class NavigationNavigating extends NavigationState {
  final String route;
  const NavigationNavigating(this.route);
}

class NavigationGoingBack extends NavigationState {
  const NavigationGoingBack();
}

class NavigationCurrentRoute extends NavigationState {
  final String route;
  const NavigationCurrentRoute(this.route);
}

/// Provider for NavigationNotifier
final navigationNotifierProvider = StateNotifierProvider<NavigationNotifier, NavigationState>((ref) {
  return NavigationNotifier();
});

/// Convenience provider for accessing navigation state
final navigationStateProvider = Provider<NavigationState>((ref) {
  return ref.watch(navigationNotifierProvider);
});

/// Convenience provider for getting current route
final currentRouteProvider = Provider<String?>((ref) {
  final navigationState = ref.watch(navigationNotifierProvider);
  return switch (navigationState) {
    NavigationCurrentRoute(route: final route) => route,
    NavigationNavigating(route: final route) => route,
    _ => null,
  };
});

/// Provider for GoRouter configuration
/// This will be implemented in the GoRouter navigation task
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => const Placeholder(), // Will be replaced with actual screens
      ),
      // Additional routes will be added in the GoRouter navigation task
    ],
  );
});