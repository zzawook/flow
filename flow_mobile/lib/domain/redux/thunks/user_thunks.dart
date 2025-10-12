import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/service/api_service/api_service.dart';
import 'package:flow_mobile/service/navigation_service.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<FlowState> setConstantUserFieldsThunk(
  DateTime dateOfBirth,
  bool isGenderMale,
) {
  return (Store store) async {
    final apiService = getIt<ApiService>();
    final navigationService = getIt<NavigationService>();
    final result = await apiService.setConstantUserFields(
      dateOfBirth,
      isGenderMale,
    );

    if (result.success) {
      // store.dispatch(openAddAccountScreenThunk());
      navigationService.pushNamed(AppRoutes.home);
    } else {
      // Handle failure
    }
  };
}
