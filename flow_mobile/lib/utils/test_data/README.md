# Recurring Spending Test Data System

This debug system allows you to test various UI states of the Recurring Spending feature without depending on the backend API.

## 🎯 Quick Start

1. **Enable Debug Mode**
   - Open `lib/utils/debug_config.dart`
   - Ensure `isDebugMode = true`

2. **Choose Test Mode**
   - In the same file, change `recurringSpendingMode` to your desired mode:
   ```dart
   static const RecurringSpendingTestMode recurringSpendingMode = 
       RecurringSpendingTestMode.multipleItems; // Change this
   ```

3. **Hot Reload**
   - Press `r` in your Flutter terminal or hot reload in your IDE

4. **Navigate to Spending Screen**
   - Open the app and go to the Spending screen
   - The Fixed Spending Card will show the test data/state you selected

## 📋 Available Test Modes

### `production`
**Use real API data (normal behavior)**
- Calls the actual backend API
- Use this when you want to test with real data
- This is the default mode

### `loading`
**Shows loading state indefinitely**
- Tests: Loading spinner positioning, user patience
- Use case: Verify loading UI works correctly
- UI: Spinning circular progress indicator

### `error`
**Shows error state**
- Tests: Error message formatting, error UI layout
- Use case: Verify error handling displays correctly
- UI: Red error icon with error message
- Message: "Test Error: Unable to connect to server..."

### `empty`
**Shows empty state**
- Tests: Empty state messaging, icon display
- Use case: Verify empty state UI for users with no recurring spending
- UI: "No recurring spendings found yet" message

### `singleItem`
**Shows 1 recurring spending item**
- Data: Netflix subscription ($15.99/month)
- Tests: Basic rendering, single item padding
- Use case: Verify layout works with minimal data

### `multipleItems`
**Shows 6 diverse recurring spending items**
- Data includes:
  - Netflix ($15.99) - Entertainment
  - Spotify ($9.99) - Entertainment  
  - Grab Food ($25.50) - Food, Weekly
  - SP Utilities ($120.00) - Utilities
  - Fitness First ($89.00) - Health
  - Singtel ($45.00) - Telecommunication
- Tests: Scrolling, category variety, amount formatting
- Use case: Verify typical user experience with multiple subscriptions

### `edgeCases`
**Shows 7 edge case scenarios**
- Very long display name (tests text truncation)
- Daily recurring ($6.50 coffee)
- Quarterly insurance ($450.00, 90-day interval)
- Bi-monthly service ($75.00, 60-day interval)
- Custom interval (every 17 days)
- Micro amount ($0.01)
- Large amount ($9,999.99)
- Tests: Boundary conditions, unusual intervals, extreme values
- Use case: Stress test the UI with unusual data

## 🔄 Example Workflow

### Testing Loading State
```dart
// In debug_config.dart
static const recurringSpendingMode = RecurringSpendingTestMode.loading;
```
Hot reload → Navigate to Spending screen → See loading spinner

### Testing Multiple Items
```dart
// In debug_config.dart
static const recurringSpendingMode = RecurringSpendingTestMode.multipleItems;
```
Hot reload → Navigate to Spending screen → See 6 recurring items

### Testing Error Handling
```dart
// In debug_config.dart
static const recurringSpendingMode = RecurringSpendingTestMode.error;
```
Hot reload → Navigate to Spending screen → See error message

### Back to Production
```dart
// In debug_config.dart
static const recurringSpendingMode = RecurringSpendingTestMode.production;
// OR
static const isDebugMode = false; // Disables all debug features
```

## 📝 Data Structure

Test data is generated in `recurring_spending_test_data.dart` with the following structure:

```dart
RecurringSpending(
  id: 1,
  displayName: 'Netflix Subscription',
  category: 'Entertainment',
  brandDomain: 'netflix.com',
  brandName: 'Netflix',
  expectedAmount: 15.99,
  nextTransactionDate: DateTime(...),
  lastTransactionDate: DateTime(...),
  intervalDays: 30,
  occurrenceCount: 12,
  transactionIds: [1001, 1002, 1003],
  year: 2025,
  month: 10,
)
```

## 🎨 UI States Covered

✅ **Loading** - Circular progress indicator  
✅ **Error** - Error icon + error message  
✅ **Empty** - "No recurring spendings found yet"  
✅ **Data** - List of recurring items with:
  - Brand logos or category icons
  - Display names (with truncation for long names)
  - Expected amounts (formatted as currency)
  - Chevron right icons for navigation

## ⚠️ Important Notes

1. **Production Builds**: Always set `isDebugMode = false` before building for production
2. **Hot Reload Required**: Changes to `debug_config.dart` require hot reload to take effect
3. **Month Context**: Test data is generated for the currently displayed month
4. **Caching**: Debug mode bypasses the 1-hour cache mechanism
5. **Loading Delay**: All test modes (except loading) include an 800ms delay to simulate network latency

## 🧪 Testing Checklist

Use this checklist to verify all UI states work correctly:

- [ ] Loading state displays correctly
- [ ] Error state shows error icon and message
- [ ] Empty state shows appropriate messaging
- [ ] Single item displays without layout issues
- [ ] Multiple items scroll smoothly
- [ ] Edge cases handle text truncation properly
- [ ] Long names are truncated at 35 characters
- [ ] Amount formatting works for all ranges ($0.01 to $9,999.99)
- [ ] Category icons display correctly
- [ ] Brand logos load (when available) or fallback to category icons
- [ ] Total amount calculation is correct
- [ ] Navigation chevrons are visible

## 📂 File Structure

```
flow_mobile/lib/
├── utils/
│   ├── debug_config.dart                    # Main debug configuration
│   └── test_data/
│       ├── recurring_spending_test_data.dart # Test data generator
│       └── README.md                         # This file
└── domain/
    └── redux/
        └── thunks/
            └── spending_screen_thunks.dart   # Modified to support debug mode
```

## 🚀 Extending This System

To add more test scenarios:

1. Add new mode to `RecurringSpendingTestMode` enum in `debug_config.dart`
2. Create new test data method in `RecurringSpendingTestData` class
3. Add switch case in `fetchRecurringSpendingThunk()` to handle the new mode
4. Update this README with the new mode description

## 💡 Tips

- **Quick Toggle**: Keep `debug_config.dart` open in a tab for quick mode switching
- **Screen Recording**: Record each mode for documentation or bug reports
- **Design Review**: Use `multipleItems` mode for design reviews
- **QA Testing**: Use `edgeCases` mode for comprehensive QA testing
- **Demo Mode**: Use `multipleItems` for demos when backend is unavailable


