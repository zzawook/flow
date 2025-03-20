import 'package:flow_mobile/domain/redux/app_state.dart';
import 'package:flow_mobile/domain/redux/reducers.dart';
import 'package:redux/redux.dart';

Store<FlowState> flowStateStore() {
  return Store<FlowState>(flowReducer, initialState: FlowState.initial());
}
