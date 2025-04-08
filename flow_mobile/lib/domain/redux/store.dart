import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/reducers.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

Store<FlowState> flowInitialStateStore(FlowState flowState) {
  return Store<FlowState>(flowReducer, initialState: FlowState.initial());
}

Store<FlowState> flowStateStore(FlowState flowState) {
  return Store<FlowState>(flowReducer, initialState: flowState, middleware: [thunkMiddleware]);
}
