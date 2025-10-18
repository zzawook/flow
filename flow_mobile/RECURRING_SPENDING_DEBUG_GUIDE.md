# 🎯 Recurring Spending Debug System - Quick Start

A comprehensive testing system for the Recurring Spending feature that allows you to test all UI states without backend dependency.

## ⚡ 3-Second Start

1. Open `lib/utils/debug_config.dart`
2. Change line 59-60:
   ```dart
   static const RecurringSpendingTestMode recurringSpendingMode = 
       RecurringSpendingTestMode.multipleItems; // ← Change this
   ```
3. Hot reload (`r`)
4. Go to Spending screen

## 🎨 Available Modes

| Mode            | What You See             | When to Use                 |
| --------------- | ------------------------ | --------------------------- |
| `production`    | Real API data            | Normal development          |
| `loading`       | Spinning loader forever  | Test loading UI             |
| `error`         | Error message            | Test error handling         |
| `empty`         | "No recurring spendings" | Test empty state            |
| `singleItem`    | 1 item (Netflix)         | Test minimal layout         |
| `multipleItems` | 6 diverse items          | **Demos, design reviews** ⭐ |
| `edgeCases`     | 7 weird scenarios        | QA, stress testing          |

## 📱 Example Test Data

### `multipleItems` (Most Useful)
```
Recurring Spendings
$ 305.48

🎬 Netflix Subscription           -$15.99  →
🎵 Spotify Premium                -$9.99   →
🍔 Grab Food Delivery             -$25.50  →
⚡ SP Utilities Bill              -$120.00 →
💪 Fitness First Gym              -$89.00  →
📱 Singtel Mobile Plan            -$45.00  →
```

### `edgeCases` (Stress Testing)
```
🛍️ This is an extremely long rec... -$299.99  →
☕ Daily Coffee Shop               -$6.50    →
🛡️ Quarterly Insurance            -$450.00  →
⚙️ Bi-Monthly Service              -$75.00   →
💳 Custom Interval Payment         -$33.33   →
❓ Micro Transaction               -$0.01    →
💎 Premium Service                -$9999.99 →
```

## 🔄 Common Workflows

### Demo Preparation
```dart
// Show nice demo data
recurringSpendingMode = RecurringSpendingTestMode.multipleItems;
```

### Testing Empty State
```dart
// Show empty state
recurringSpendingMode = RecurringSpendingTestMode.empty;
```

### Testing Error Handling
```dart
// Show error
recurringSpendingMode = RecurringSpendingTestMode.error;
```

### Back to Normal
```dart
// Use real API
recurringSpendingMode = RecurringSpendingTestMode.production;
```

## 🚀 Pro Tips

1. **Keep debug_config.dart Open**: Pin it in your IDE for quick switching
2. **Hot Reload Works**: No need to restart app, just hot reload
3. **Works Per Month**: Test data adapts to displayed month
4. **Network Delay**: 800ms delay simulates real API calls
5. **Production Safe**: Just set `isDebugMode = false` before release

## ⚠️ Before Production Release

```dart
// In debug_config.dart
static const bool isDebugMode = false; // ← Must be false!
```

## 📚 Full Documentation

For detailed information, see:
- `lib/utils/test_data/README.md` - Complete documentation
- `lib/utils/debug_config.dart` - Configuration file (with quick reference)
- `lib/utils/test_data/recurring_spending_test_data.dart` - Test data source

## 🧪 Testing Checklist

Quick test all states:

```dart
// 1. Test loading
recurringSpendingMode = RecurringSpendingTestMode.loading;
// Hot reload → See spinner

// 2. Test error  
recurringSpendingMode = RecurringSpendingTestMode.error;
// Hot reload → See error message

// 3. Test empty
recurringSpendingMode = RecurringSpendingTestMode.empty;
// Hot reload → See "No recurring spendings"

// 4. Test data
recurringSpendingMode = RecurringSpendingTestMode.multipleItems;
// Hot reload → See 6 items

// 5. Test edge cases
recurringSpendingMode = RecurringSpendingTestMode.edgeCases;
// Hot reload → See extreme scenarios

// 6. Back to normal
recurringSpendingMode = RecurringSpendingTestMode.production;
// Hot reload → Real API data
```

## 💡 Use Cases

- **👨‍💼 Product Demos**: Use `multipleItems` to show feature without real data
- **🎨 Design Review**: Use `multipleItems` to review UI with designers
- **🐛 Bug Reproduction**: Use specific modes to isolate UI issues
- **✅ QA Testing**: Use `edgeCases` to test boundary conditions
- **📱 Screenshots**: Use test data for App Store screenshots
- **🧪 Unit Testing**: Reference test data structure for tests

## 🏗️ Architecture

```
User opens Spending screen
    ↓
fetchRecurringSpendingThunk() called
    ↓
Check: Is DebugConfig.isDebugMode true?
    ↓ YES
    Switch on recurringSpendingMode
        → loading: Stay in loading state
        → error: Show test error
        → empty: Return empty array
        → singleItem: Return 1 test item
        → multipleItems: Return 6 test items
        → edgeCases: Return 7 edge cases
        → production: Continue to API call
    ↓ NO
    Continue to normal API call
```

---

**Questions?** See `lib/utils/test_data/README.md` for detailed documentation.



