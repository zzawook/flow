import 'package:flow_mobile/presentation/navigation/transition_type.dart';

/// A custom class to encapsulate additional route arguments,
/// including the transition type.
class CustomPageRouteArguments {
  final TransitionType transitionType;
  final Object? extraData; // Any extra data you might need.
  
  CustomPageRouteArguments({
    required this.transitionType,
    this.extraData,
  });
}