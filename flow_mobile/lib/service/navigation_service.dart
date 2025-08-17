import 'package:flutter/material.dart';

class NavigationService {
  final navigatorKey = GlobalKey<NavigatorState>();

  Future<T?> pushNamed<T extends Object?>(String route, {Object? arguments}) =>
      navigatorKey.currentState!.pushNamed<T>(route, arguments: arguments);

  Future<void> pushNamedAndRemoveUntil(String route) =>
      navigatorKey.currentState!.pushNamedAndRemoveUntil(route, (r) => false);
}