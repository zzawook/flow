import 'package:flow_mobile/domain/redux/actions/screen_actions.dart';
import 'package:flow_mobile/domain/redux/states/screen_state.dart';

ScreenState screenReducer(ScreenState state, dynamic action) {
  if (action is NavigateToScreenAction) {
    return state.copyWith(screenName: action.screenName);
  }
  return state;
}