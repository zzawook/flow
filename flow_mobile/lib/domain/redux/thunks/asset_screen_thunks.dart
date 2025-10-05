import 'package:flow_mobile/domain/redux/actions/asset_screen_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/service/api_service/api_service.dart';
import 'package:flow_mobile/utils/debug_config.dart';
import 'package:flow_mobile/utils/test_data/monthly_asset_test_data.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

/// Fetches last 6 months end-of-month asset data from backend
///
/// Debug Mode: If DebugConfig.isDebugMode is true, returns test data
/// based on DebugConfig.monthlyAssetTestMode instead of making API calls
ThunkAction<FlowState> fetchMonthlyAssetsThunk() {
  return (Store<FlowState> store) async {
    // ======== DEBUG MODE HANDLING ========
    if (DebugConfig.isDebugMode) {
      final testMode = DebugConfig.monthlyAssetTestMode;

      switch (testMode) {
        case MonthlyAssetTestMode.loading:
          // Show loading state indefinitely
          store.dispatch(SetMonthlyAssetsLoadingAction(true));
          return;

        case MonthlyAssetTestMode.error:
          // Show error after short delay
          store.dispatch(SetMonthlyAssetsLoadingAction(true));
          await Future.delayed(const Duration(milliseconds: 800));
          store.dispatch(
            SetMonthlyAssetsErrorAction('Failed to load asset data'),
          );
          return;

        case MonthlyAssetTestMode.empty:
          // Show empty state after short delay
          store.dispatch(SetMonthlyAssetsLoadingAction(true));
          await Future.delayed(const Duration(milliseconds: 800));
          store.dispatch(
            SetMonthlyAssetsAction(MonthlyAssetTestData.getEmpty()),
          );
          return;

        case MonthlyAssetTestMode.multipleItems:
          // Show normal data after short delay
          store.dispatch(SetMonthlyAssetsLoadingAction(true));
          await Future.delayed(const Duration(milliseconds: 800));
          store.dispatch(
            SetMonthlyAssetsAction(MonthlyAssetTestData.getMultipleItems()),
          );
          return;

        case MonthlyAssetTestMode.edgeCases:
          // Show edge cases after short delay
          store.dispatch(SetMonthlyAssetsLoadingAction(true));
          await Future.delayed(const Duration(milliseconds: 800));
          store.dispatch(
            SetMonthlyAssetsAction(MonthlyAssetTestData.getEdgeCases()),
          );
          return;

        case MonthlyAssetTestMode.production:
          // Fall through to normal production code below
          break;
      }
    }
    // ======== END DEBUG MODE HANDLING ========

    // Set loading state
    store.dispatch(SetMonthlyAssetsLoadingAction(true));

    try {
      final apiService = getIt<ApiService>();
      final response = await apiService.getLast6MonthsAssets();

      // Convert proto DailyAsset list to Map<DateTime, double>
      final Map<DateTime, double> monthlyAssets = {};
      for (var dailyAsset in response.dailyAssets) {
        // Convert protobuf Timestamp to DateTime
        final assetDate = DateTime.fromMillisecondsSinceEpoch(
          dailyAsset.assetDate.seconds.toInt() * 1000,
        );
        monthlyAssets[assetDate] = dailyAsset.totalAssetValue;
      }

      // Dispatch success action
      store.dispatch(SetMonthlyAssetsAction(monthlyAssets));
    } catch (error) {
      // Dispatch error action
      String errorMessage = 'Failed to load asset data';

      if (error.toString().contains('UNAUTHENTICATED')) {
        errorMessage = 'Please log in again';
      } else if (error.toString().contains('NOT_FOUND')) {
        errorMessage = 'No asset data available';
      }

      store.dispatch(SetMonthlyAssetsErrorAction(errorMessage));
    }
  };
}

