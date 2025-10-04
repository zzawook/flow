# Spending Median Comparison - Mobile Integration

## Overview

Successfully integrated the backend spending median API into the Flutter mobile app's `DemographicAnalysisCard`. The card now displays real-time comparison of the user's spending against the median spending of their age group.

## Implementation Summary

### ✅ Completed Components

1. **Proto Generation**
   - Generated Dart proto files from updated `transaction_history.proto`
   - New RPC: `GetSpendingMedianForAgeGroup`
   - New messages: `GetSpendingMedianRequest`, `GetSpendingMedianResponse`

2. **State Management**
   - Updated `SpendingScreenState` to store median data
   - Created `SpendingMedianData` helper class with formatted age group display
   - Caches median data per month with key format: "YYYY-MM"
   - Tracks loading and error states

3. **Redux Actions** (`spending_screen_actions.dart`)
   - `FetchSpendingMedianAction` - Triggers fetch
   - `SetSpendingMedianLoadingAction` - Controls loading state
   - `SetSpendingMedianAction` - Stores fetched data
   - `SetSpendingMedianErrorAction` - Handles errors

4. **Redux Reducer** (`spending_screen_reducer.dart`)
   - Handles all median-related actions
   - Updates state immutably
   - Maintains cache map of medians by month

5. **API Service Layer**
   - `TransactionHistoryApiService.getSpendingMedianForAgeGroup()` - gRPC call
   - `ApiService.getSpendingMedianForAgeGroup()` - Exposed to app

6. **Thunks** (`spending_screen_thunks.dart`)
   - `fetchSpendingMedianThunk()` - Main fetch logic
   - Checks cache before fetching
   - Handles errors with user-friendly messages
   - Auto-fetches when month changes

7. **UI Components**
   - **`AnalysisCarousel`**: 
     - Uses `StoreConnector` to access state
     - Fetches data on mount
     - Passes data to `DemographicAnalysisCard`
   
   - **`DemographicAnalysisCard`**: 
     - Displays real median data
     - Shows formatted age group ("Ages 20-29")
     - Loading state with spinner
     - Error state with friendly message
     - Animated bar chart comparison

## Architecture Flow

```
User Changes Month
        ↓
setDisplayedMonthThunk()
        ↓
fetchSpendingMedianThunk()
        ↓
Check Cache → If not cached → API Call
        ↓
SetSpendingMedianAction
        ↓
spendingScreenReducer
        ↓
State Updated
        ↓
AnalysisCarousel Rebuilds
        ↓
DemographicAnalysisCard Updates UI
```

## Key Features

### 1. **Smart Caching**
- Caches median data for visited months
- Prevents redundant API calls
- Key format: "YYYY-MM"

### 2. **Automatic Fetching**
- Fetches on initial mount
- Fetches when user navigates to new month
- No manual refresh needed

### 3. **User-Friendly Error Handling**
```dart
- NOT_FOUND → "No data available for your age group this month"
- FAILED_PRECONDITION → "Please update your date of birth in settings"
- UNAUTHENTICATED → "Please log in again"
- Default → "Not enough data for comparison"
```

### 4. **Age Group Formatting**
- Backend returns: "20s"
- UI displays: "Ages 20-29"
- Supports: 0s through 150s

### 5. **Loading States**
- Shows spinner while fetching
- "Loading comparison data..." message
- Graceful fallback if no data

### 6. **Uses displayedMonth**
- Consistent with spending screen state
- Shows comparison for currently viewed month
- Not hardcoded to current month

## Files Modified

### Created
- `/home/kjaehyeok21/dev/flow/flow_mobile/docs/SPENDING_MEDIAN_INTEGRATION.md`

### Modified
1. `lib/domain/redux/states/spending_screen_state.dart`
   - Added `SpendingMedianData` class
   - Added median caching fields
   - Added helper methods

2. `lib/domain/redux/actions/spending_screen_actions.dart`
   - Added 4 new actions for median management

3. `lib/domain/redux/reducers/spending_screen_reducer.dart`
   - Added handlers for median actions

4. `lib/domain/redux/thunks/spending_screen_thunks.dart`
   - Added `fetchSpendingMedianThunk()`
   - Updated month change thunks to fetch median

5. `lib/service/api_service/transaction_history_api_service.dart`
   - Added `getSpendingMedianForAgeGroup()` method

6. `lib/service/api_service/api_service.dart`
   - Exposed median API

7. `lib/presentation/spending_screen/components/special_analysis_card/analysis_carousel.dart`
   - Refactored to use `StoreConnector`
   - Added `AnalysisCarouselState` class
   - Fetches data on mount

8. `lib/presentation/spending_screen/components/special_analysis_card/analysis/demographic_analysis_card.dart`
   - Complete refactor to use real data
   - Added loading state
   - Added error handling
   - Dynamic age group display

## Testing Checklist

- [ ] **Initial Load**: Open spending screen → Should show loading, then median data
- [ ] **Month Navigation**: Change month → Should fetch new median (or use cache)
- [ ] **Cache Test**: Navigate back to previous month → Should load instantly (cached)
- [ ] **Error Handling**: 
  - User without DOB → Should show "Update date of birth" message
  - No data for age group → Should show "No data available" message
- [ ] **Visual Test**: 
  - Bar heights adjust correctly
  - Age group label shows formatted text ("Ages XX-YY")
  - Amounts display properly

## Future Enhancements

1. **Pull to Refresh**: Manual refresh to get updated median
2. **Percentile Display**: Show "You're in the top 25%" messaging
3. **Category Breakdown**: Compare spending by category
4. **Trend Over Time**: Show how median changes month-to-month
5. **Regional Comparison**: Add city/country-level comparison

## API Contract

### Request
```dart
GetSpendingMedianRequest {
  int? year;  // Optional, defaults to current month (SGT)
  int? month; // Optional
}
```

### Response
```dart
GetSpendingMedianResponse {
  String ageGroup;            // e.g., "20s"
  double medianSpending;      // Positive value
  int year;
  int month;
  int userCount;              // Users in age group
  Timestamp calculatedAt;
}
```

### Error Codes
- `UNAUTHENTICATED` - User not logged in
- `INVALID_ARGUMENT` - Invalid year/month
- `FAILED_PRECONDITION` - No date of birth
- `NOT_FOUND` - No data for age group/month

## Developer Notes

### State Access Pattern
```dart
// Get median for specific month
final median = store.state.screenState.spendingScreenState.getMedianForMonth(month);

// Check if cached
final hasCached = store.state.screenState.spendingScreenState.hasMedianForMonth(month);

// Get displayed month
final displayedMonth = store.state.screenState.spendingScreenState.displayedMonth;
```

### Manual Fetch
```dart
store.dispatch(fetchSpendingMedianThunk(DateTime(2025, 10)));
```

### Formatted Age Group
```dart
final data = SpendingMedianData(ageGroup: "20s", ...);
print(data.formattedAgeGroup); // "Ages 20-29"
```

## Deployment Notes

1. **Backend Must Be Running**: Ensure backend has median calculation scheduled task active
2. **Proto Files**: Ensure proto files are up to date on both sides
3. **Date of Birth**: Users should have DOB set for feature to work
4. **Timezone**: All calculations use SGT (Asia/Singapore)

## Success Criteria ✅

- [x] Fetches real median data from backend
- [x] Displays formatted age group
- [x] Caches data per month
- [x] Auto-fetches on month change
- [x] Shows loading state
- [x] Handles errors gracefully
- [x] Uses `displayedMonth` from spending screen state
- [x] Uses `getExpenseForMonth()` for user's spending
- [x] Passes Flutter analyzer with no errors

---

**Implementation Date**: October 4, 2025  
**Backend API**: `/sg.flow.transaction.v1.TransactionHistoryService/GetSpendingMedianForAgeGroup`  
**Status**: ✅ Complete & Ready for Testing

