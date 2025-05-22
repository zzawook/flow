import 'package:flutter/material.dart';
import 'transition_type.dart';

class AppTransitions {
  static Widget build(
    TransitionType type,
    Animation<double> animation,
    Widget child,
  ) {
    final tween = _offset(type).chain(CurveTween(curve: Curves.easeInOut));
    return SlideTransition(position: animation.drive(tween), child: child);
  }

  static Tween<Offset> _offset(TransitionType type) {
    switch (type) {
      case TransitionType.slideRight:
        return Tween(begin: const Offset(-1, 0), end: Offset.zero);
      case TransitionType.slideTop:
        return Tween(begin: const Offset(0, -1), end: Offset.zero);
      case TransitionType.slideBottom:
        return Tween(begin: const Offset(0, 1), end: Offset.zero);
      case TransitionType.slideLeft:
        return Tween(begin: const Offset(1, 0), end: Offset.zero);
    }
  }
}
