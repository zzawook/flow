# Monthly Asset Feature Integration - Flutter Mobile

## Overview

This document describes the integration of the Daily Asset backend feature into the Flutter mobile application, specifically for the `MonthlyAssetBarChart` component in the Asset Screen.

## Implementation Summary

### Architecture Pattern

Following the existing Redux architecture:
- **State Management**: AssetScreenState within ScreenState
- **Data Fetching**: Direct API calls via thunks (no local persistence)
- **Loading Strategy**: Data fetched when AssetScreen mounts
- **Debug Support**: Full test mode support following existing patterns

### Files Created (7 new files)

1. **`lib/domain/redux/states/asset_screen_state.dart`**
   - Manages monthly asset data, loading state, and errors
   - Contains `Map<DateTime, double>` for asset data

2. **`lib/domain/redux/actions/asset_screen_actions.dart`**
   - `SetMonthlyAssetsAction` - Update asset data
   - `SetMonthlyAssetsLoadingAction` - Toggle loading state
   - `SetMonthlyAssetsErrorAction` - Set error message
   - `ClearMonthlyAssetsErrorAction` - Clear errors

3. **`lib/domain/redux/reducers/asset_screen_reducer.dart`**
   - Pure reducer function handling asset screen actions

4. **`lib/domain/redux/thunks/asset_screen_thunks.dart`**
   - `fetchMonthlyAssetsThunk()` - Fetches data from backend
   - Includes full debug mode support

5. **`lib/utils/test_data/monthly_asset_test_data.dart`**
   - Test data for debugging various states
   - Includes normal, empty, and edge case scenarios

### Files Modified (8 files)

1. **`lib/service/api_service/account_api_service.dart`**
   - Added `getLast6MonthsAssets()` method

2. **`lib/service/api_service/api_service.dart`**
   - Exposed `getLast6MonthsAssets()` method

3. **`lib/domain/redux/states/screen_state.dart`**
   - Added `assetScreenState` field
   - Updated all methods to include new state

4. **`lib/domain/redux/reducers/screen_reducer.dart`**
   - Integrated asset screen reducer
   - Added action routing for asset actions

5. **`lib/utils/debug_config.dart`**
   - Added `MonthlyAssetTestMode` enum
   - Added `monthlyAssetTestMode` configuration

6. **`lib/presentation/asset_screen/asset_screen.dart`**
   - Converted to StatefulWidget
   - Dispatches `fetchMonthlyAssetsThunk()` on mount

7. **`lib/presentation/asset_screen/components/total_asset_card/total_asset_card.dart`**
   - Converted to use `StoreConnector`
   - Removed hard-coded data
   - Added loading, error, and empty states
   - Connected to Redux state

## How It Works

### Data Flow

```
AssetScreen (mounts)
  ↓
Dispatches fetchMonthlyAssetsThunk()
  ↓
Sets loading state (SetMonthlyAssetsLoadingAction)
  ↓
Calls ApiService.getLast6MonthsAssets()
  ↓
AccountApiService.getLast6MonthsAssets() (gRPC call)
  ↓
Backend: AccountGrpcService.getLast6MonthsEndOfMonthAssets()
  ↓
Returns GetLast6MonthsEndOfMonthAssetsResponse
  ↓
Converts proto to Map<DateTime, double>
  ↓
Dispatches SetMonthlyAssetsAction with data
  ↓
AssetScreenState updates in Redux
  ↓
TotalAssetCard (StoreConnector) rebuilds
  ↓
MonthlyAssetBarChart renders with real data
```

### State Structure

```dart
AssetScreenState {
  monthlyAssets: Map<DateTime, double> // Asset values by date
  isLoading: bool                       // Loading indicator
  error: String?                        // Error message if any
}
```

### UI States

1. **Loading**: Shows `CircularProgressIndicator` while fetching
2. **Error**: Shows error icon and message if API call fails
3. **Empty**: Shows "No asset data available" if response is empty
4. **Success**: Renders `MonthlyAssetBarChart` with data

## Testing

### Debug Mode Testing

To test different scenarios without backend:

1. Open `lib/utils/debug_config.dart`
2. Set `isDebugMode = true`
3. Change `monthlyAssetTestMode` to desired mode:
   - `production` - Use real API (default)
   - `loading` - Show loading state indefinitely
   - `error` - Show error state
   - `empty` - Show empty state
   - `multipleItems` - Show normal 6-month data
   - `edgeCases` - Show edge cases (zero, negative, huge amounts)
4. Hot reload the app
5. Navigate to Asset Screen

### Production Testing

1. Set `isDebugMode = false` in `debug_config.dart`
2. Ensure backend is running with daily asset data
3. Launch app and navigate to Asset Screen
4. Chart should load with real monthly asset data

### Expected Behavior

- Data fetches when Asset Screen mounts (minimal loading time)
- Chart displays 6 bars representing last 6 months
- Most recent month highlighted in green
- Labels show compact format (e.g., "12K" for 12000)
- Comparison message shows increase/decrease from last month

## API Integration Details

### Endpoint
- **RPC**: `GetLast6MonthsEndOfMonthAssets`
- **Request**: `GetLast6MonthsEndOfMonthAssetsRequest` (empty)
- **Response**: `GetLast6MonthsEndOfMonthAssetsResponse`

### Response Structure
```protobuf
message GetLast6MonthsEndOfMonthAssetsResponse {
  repeated DailyAsset daily_assets = 1;
}

message DailyAsset {
  google.protobuf.Timestamp asset_date = 1;
  double total_asset_value = 2;
  int32 account_count = 3;
  google.protobuf.Timestamp calculated_at = 4;
}
```

### Data Transformation

Proto `DailyAsset` → Dart `Map<DateTime, double>`
- Converts `Timestamp` to `DateTime`
- Maps `asset_date` to `total_asset_value`
- Used directly by `MonthlyAssetBarChart`

## Error Handling

### Network Errors
- **Timeout**: "Failed to load asset data"
- **Unauthenticated**: "Please log in again"
- **Not Found**: "No asset data available"

### Empty Data
- Shows friendly "No asset data available" message
- Icon and text displayed in chart area

### Edge Cases Handled
- Less than 2 months of data (no comparison message)
- Empty response (shows empty state)
- Negative balances (debt scenario)
- Zero balances
- Extremely large amounts (formatted with compact notation)

## Performance Considerations

1. **No Local Persistence**: Data refetched on each screen mount
   - Trade-off: Fresh data vs. network overhead
   - Acceptable since asset data is small (~6 data points)

2. **Lazy Loading**: Only fetches when user visits Asset Screen
   - Reduces initial app load time
   - User experiences minimal delay (fast gRPC call)

3. **Redux Caching**: Data cached in Redux during session
   - Persists across navigation within session
   - Cleared on logout

## Future Enhancements

Potential improvements:

1. **Pull-to-Refresh**: Add refresh gesture to TotalAssetCard
2. **Local Caching**: Store data in Hive with TTL (e.g., 1 hour)
3. **Animations**: Add chart animation on data load
4. **Interactive Chart**: Tap bars to see detailed breakdown
5. **Date Range Selector**: Allow user to choose custom date ranges

## Troubleshooting

### Chart Not Loading

**Symptom**: Loading indicator shows indefinitely

**Possible Causes**:
1. Backend not running
2. Proto files not regenerated after backend changes
3. Network connectivity issues
4. Authentication token expired

**Solutions**:
- Check backend logs
- Regenerate proto files: `cd grpc_contract && ./generate_dart_proto.sh`
- Check network connection
- Re-login to refresh token

### Empty Chart Displayed

**Symptom**: "No asset data available" shows when data exists

**Possible Causes**:
1. Daily asset calculation hasn't run yet (runs at midnight SGT)
2. User has no accounts linked
3. Backend database issue

**Solutions**:
- Wait until after midnight SGT or trigger manual calculation
- Link at least one bank account
- Check backend logs and database

### Wrong Data Displayed

**Symptom**: Chart shows incorrect or stale data

**Possible Causes**:
1. Debug mode enabled with test data
2. Backend data calculation issue
3. Timezone mismatch

**Solutions**:
- Disable debug mode: `isDebugMode = false`
- Verify backend calculation logic
- Check timezone settings (should be SGT)

## Related Documentation

- Backend: `be/docs/DAILY_ASSET_TRACKING.md`
- Proto Contract: `grpc_contract/account/v1/account.proto`
- Component: `flow_mobile/lib/presentation/asset_screen/components/total_asset_card/monthly_asset_bar_chart.dart`

