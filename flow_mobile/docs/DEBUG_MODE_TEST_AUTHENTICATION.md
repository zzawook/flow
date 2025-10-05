# Debug Mode: Test Authentication & Transaction History

## Overview
This document describes the debug mode implementation for testing authentication and transaction history without backend dependencies.

## Quick Start

### 1. Enable Debug Mode
In `lib/utils/debug_config.dart`:
```dart
class DebugConfig {
  static const bool isDebugMode = true;  // Enable debug mode
  
  static const AuthTestMode authTestMode = AuthTestMode.testAccount;
  static const TransactionHistoryTestMode transactionHistoryTestMode = 
      TransactionHistoryTestMode.multipleItems;
  static const UserProfileTestMode userProfileTestMode = 
      UserProfileTestMode.testUser;
}
```

### 2. Test Login
- **Email**: `kjaehyeok21@gmail.com`
- **Password**: Any password (will be bypassed in test mode)

In test mode, authentication skips:
- ✅ Backend API calls
- ✅ Email verification
- ✅ Token validation

## Configuration Options

### AuthTestMode
- `production`: Use real API authentication
- `testAccount`: Skip authentication, use mock credentials, go directly to home

### TransactionHistoryTestMode
- `production`: Use real API data
- `singleItemPerMonth`: 6 transactions (1 per month for last 6 months)
- `multipleItems`: ~300 transactions (~50 per month for 6 months)

### UserProfileTestMode
- `production`: Use real API data
- `testUser`: Use test user profile
  - Email: kjaehyeok21@gmail.com
  - Date of Birth: January 25, 2002
  - Name: Test User

## Test Data

### Bank Accounts
When in test mode, 2 mock bank accounts are created:

1. **DBS Savings Account**
   - Account Number: 1234567890
   - Balance: $8,500.00
   - Type: SAVINGS

2. **OCBC 360 Account**
   - Account Number: 9876543210
   - Balance: $3,200.00
   - Type: CURRENT

### Transactions

#### singleItemPerMonth Mode
- 6 transactions total
- 1 transaction per month for the last 6 months
- Simple testing scenario

#### multipleItems Mode
- ~300 transactions total
- ~50 transactions per month for 6 months
- Realistic data volume with diverse:
  - Categories: Food, Entertainment, Shopping, Transportation, Travel, Utilities, Health, Grocery, Telecommunication
  - Merchants: McDonald's, Starbucks, Netflix, Spotify, Amazon, Grab, Singtel, etc.
  - Amounts: $5 - $200 for expenses, $500 - $5000 for income
  - Payment methods: CARD, TRANSFER
  - 90% expenses, 10% income

### Available Categories
Based on icons in `assets/icons/category_icons/`:
- Food
- Entertainment
- Shopping
- Transportation
- Travel
- Utilities
- Telecommunication
- Health
- Grocery
- Transfer
- Others

## How It Works

### Login Flow (Test Mode)

```
User enters email & password
         ↓
loginThunk checks DebugConfig
         ↓
If testAccount mode:
  → Create mock tokens
  → Skip API authentication
  → Call _initStateForLoggedInUser
  → Load test data (user, accounts, transactions)
  → Navigate directly to home
  → Skip email verification
```

### Data Loading (Test Mode)

```
_initStateForLoggedInUser
         ↓
Clear existing data
         ↓
Load test user profile
         ↓
Load test bank accounts (DBS & OCBC)
         ↓
Load test transactions (based on mode)
         ↓
Dispatch Redux actions to update state
         ↓
Complete (skip notifications)
```

## Files Modified

### New Files Created
1. `lib/utils/test_data/bank_account_test_data.dart` - Mock bank accounts
2. `lib/utils/test_data/user_test_data.dart` - Mock user profile
3. `lib/utils/test_data/transaction_history_test_data.dart` - Mock transactions

### Modified Files
1. `lib/utils/debug_config.dart` - Added new test mode enums
2. `lib/domain/redux/thunks/auth_thunks.dart` - Added debug mode handling
3. `lib/domain/manager/bank_manager_impl.dart` - Added OCBC to banks list

## Production Deployment

⚠️ **IMPORTANT**: Before deploying to production, set:
```dart
static const bool isDebugMode = false;
```

This ensures all debug shortcuts are disabled and the app uses real backend APIs.

## Signup Behavior

- **Production mode**: Normal signup flow with email verification
- **Test mode**: Signup remains production behavior (as requested)

Only login is affected by test mode.

## Benefits

1. ✅ **Fast Testing**: Skip authentication and bank linking
2. ✅ **Offline Development**: Work without backend dependencies
3. ✅ **Consistent Test Data**: Fixed seed for reproducible results
4. ✅ **Realistic Scenarios**: Diverse transaction categories and amounts
5. ✅ **Easy Toggle**: Single flag to switch between test/production

## Example Usage

```dart
// Enable test mode
DebugConfig.isDebugMode = true;
DebugConfig.authTestMode = AuthTestMode.testAccount;

// Choose transaction volume
DebugConfig.transactionHistoryTestMode = 
    TransactionHistoryTestMode.singleItemPerMonth;  // Minimal
    // or
    TransactionHistoryTestMode.multipleItems;        // Realistic

// Hot reload and test!
```

## Troubleshooting

**Q: I'm still seeing authentication errors**
- A: Make sure `isDebugMode = true` and `authTestMode = AuthTestMode.testAccount`

**Q: No transactions are showing**
- A: Check `transactionHistoryTestMode` is not set to `production`

**Q: Bank accounts not appearing**
- A: Ensure you're logging in (not signing up) and using test mode

**Q: Want to test with different data volumes**
- A: Switch between `singleItemPerMonth` and `multipleItems` modes

