# Daily Asset Tracking Feature

## Overview

This feature tracks each user's total asset value (sum of all bank account balances) at the end of each day. It provides historical portfolio value tracking and enables users to see how their net worth changes over time.

## Architecture

### Components

1. **Database Schema**: `daily_user_assets` table
2. **Entity**: `DailyUserAsset`
3. **Repository**: `DailyAssetRepository` with efficient bulk SQL calculation
4. **Scheduled Service**: `DailyAssetCalculationService` - runs daily at midnight SGT
5. **Query Service**: `DailyAssetService` - handles user queries
6. **gRPC API**: Three endpoints in `AccountService`
7. **Bootstrap Check**: `DailyAssetBootstrapCheck` - validates on startup
8. **Configuration**: `DailyAssetProperties` with `application.yml` settings

## Database Schema

```sql
CREATE TABLE IF NOT EXISTS daily_user_assets (
    id BIGSERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) NOT NULL,
    asset_date DATE NOT NULL,
    total_asset_value DECIMAL(15,2) NOT NULL,  -- Can be positive or negative
    account_count INT NOT NULL,
    calculated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, asset_date)
);

CREATE INDEX IF NOT EXISTS idx_daily_assets_user_date ON daily_user_assets(user_id, asset_date DESC);
CREATE INDEX IF NOT EXISTS idx_daily_assets_date ON daily_user_assets(asset_date);
```

## Asset Calculation Logic

The total asset value is calculated using:

1. **Included Accounts**:
   - ALL account types (SAVINGS, CURRENT, CREDIT_CARD, DEBIT_CARD, etc.)
   - Both positive and negative balances

2. **Calculation Method**:
   - Sum all account balances for each user
   - Store with date and metadata
   - Single efficient SQL query processes all users at once

3. **SQL Query**:
```sql
INSERT INTO daily_user_assets (user_id, asset_date, total_asset_value, account_count, calculated_at)
SELECT 
    a.user_id,
    ? AS asset_date,
    COALESCE(SUM(a.balance), 0) AS total_asset_value,
    COUNT(a.id) AS account_count,
    NOW() AS calculated_at
FROM accounts a
WHERE a.user_id IN (SELECT id FROM users)
GROUP BY a.user_id
ON CONFLICT (user_id, asset_date) 
DO UPDATE SET
    total_asset_value = EXCLUDED.total_asset_value,
    account_count = EXCLUDED.account_count,
    calculated_at = NOW();
```

## Scheduled Task

### Configuration

```yaml
flow:
  daily-asset:
    enabled: true
```

### Behavior

- **Schedule**: Every day at midnight (`@Scheduled(cron = "0 0 0 * * *")`) in SGT timezone
- **Actions**:
  1. Calculates total asset value for all users
  2. Stores in `daily_user_assets` table
  3. Updates if record already exists (upsert behavior)
- **Performance**: Single SQL query processes all users efficiently

### Enable/Disable

Set `flow.daily-asset.enabled: false` in `application.yml` to disable the scheduled task.

## Bootstrap Check

On application startup:
1. Checks if any users are missing today's asset data
2. If missing users found, immediately calculates today's assets
3. Ensures data is always up-to-date

## gRPC API

### Service Definition

```protobuf
service AccountService {
  rpc GetDailyAssets (GetDailyAssetsRequest) returns (GetDailyAssetsResponse);
  rpc GetLast7DaysAssets (GetLast7DaysAssetsRequest) returns (GetLast7DaysAssetsResponse);
  rpc GetLast6MonthsEndOfMonthAssets (GetLast6MonthsEndOfMonthAssetsRequest) returns (GetLast6MonthsEndOfMonthAssetsResponse);
}
```

### 1. GetDailyAssets - General Date Range Query

**Request:**
```protobuf
message GetDailyAssetsRequest {
  google.protobuf.Timestamp start_date = 1;
  google.protobuf.Timestamp end_date = 2;
}
```

**Response:**
```protobuf
message GetDailyAssetsResponse {
  repeated DailyAsset daily_assets = 1;
}

message DailyAsset {
  google.protobuf.Timestamp asset_date = 1;
  double total_asset_value = 2;
  int32 account_count = 3;
  google.protobuf.Timestamp calculated_at = 4;
}
```

**Usage Example:**
```kotlin
// Fetch assets for January 2025
val startDate = Timestamp.newBuilder()
    .setSeconds(LocalDate.of(2025, 1, 1).atStartOfDay(ZoneOffset.UTC).toEpochSecond())
    .build()
val endDate = Timestamp.newBuilder()
    .setSeconds(LocalDate.of(2025, 1, 31).atStartOfDay(ZoneOffset.UTC).toEpochSecond())
    .build()

val request = GetDailyAssetsRequest.newBuilder()
    .setStartDate(startDate)
    .setEndDate(endDate)
    .build()

val response = accountService.getDailyAssets(request)
// response.dailyAssetsList contains assets for each day in January
```

### 2. GetLast7DaysAssets - Convenience Method

**Request:**
```protobuf
message GetLast7DaysAssetsRequest {}
```

**Response:**
```protobuf
message GetLast7DaysAssetsResponse {
  repeated DailyAsset daily_assets = 1;
}
```

**Usage Example:**
```kotlin
val request = GetLast7DaysAssetsRequest.newBuilder().build()
val response = accountService.getLast7DaysAssets(request)
// response.dailyAssetsList contains assets for last 7 days (most recent first)
```

### 3. GetLast6MonthsEndOfMonthAssets - Monthly Snapshots

**Request:**
```protobuf
message GetLast6MonthsEndOfMonthAssetsRequest {}
```

**Response:**
```protobuf
message GetLast6MonthsEndOfMonthAssetsResponse {
  repeated DailyAsset daily_assets = 1;
}
```

**Behavior:**
- Returns asset values from the **last day** of each of the past 6 months
- Example: If today is 2025-10-15, returns assets for:
  - 2025-09-30 (September end)
  - 2025-08-31 (August end)
  - 2025-07-31 (July end)
  - 2025-06-30 (June end)
  - 2025-05-31 (May end)
  - 2025-04-30 (April end)
- Returned in chronological order (oldest to newest)

**Usage Example:**
```kotlin
val request = GetLast6MonthsEndOfMonthAssetsRequest.newBuilder().build()
val response = accountService.getLast6MonthsEndOfMonthAssets(request)
// response.dailyAssetsList contains up to 6 end-of-month snapshots
```

## Error Handling

| Status                | Description                                  |
| --------------------- | -------------------------------------------- |
| `UNAUTHENTICATED`     | User not authenticated                       |
| `INVALID_ARGUMENT`    | Invalid date range or timestamps             |

**Note**: Empty results are returned as empty lists (not errors), as users may not have asset data for all requested dates.

## Use Cases

### 1. Portfolio Tracking
Users can see how their total net worth changes over time:
```kotlin
val last7Days = accountService.getLast7DaysAssets(request)
// Display daily portfolio value chart
```

### 2. Monthly Growth Analysis
Track end-of-month snapshots to see monthly portfolio growth:
```kotlin
val last6Months = accountService.getLast6MonthsEndOfMonthAssets(request)
// Display monthly bar chart or growth percentage
```

### 3. Custom Date Range Analysis
Query specific periods for detailed analysis:
```kotlin
// Compare Q1 vs Q4 2024
val q1Request = GetDailyAssetsRequest.newBuilder()
    .setStartDate(toTimestamp(2024, 1, 1))
    .setEndDate(toTimestamp(2024, 3, 31))
    .build()
```

## Client Integration

The mobile app can:

1. **Dashboard Widget**: Display current total asset value and 7-day trend
2. **Portfolio Screen**: Show line chart of last 30 days or 6 months
3. **Analytics**: Calculate growth rate, volatility, best/worst days
4. **Notifications**: Alert users on significant portfolio changes

## Timezone

All calculations use **Singapore Time (SGT)** (`Asia/Singapore` timezone) to ensure consistency with the application's primary market.

## Performance Considerations

1. **Bulk Calculation**: Single SQL query calculates all users at once (efficient)
2. **Indexed Lookups**: Fast retrieval via `idx_daily_assets_user_date`
3. **Daily Execution**: Calculation runs only once per day at midnight
4. **No Backfill**: Cannot reconstruct historical balances (data starts from first calculation)

## Troubleshooting

### No Data Returned

**Problem**: API returns empty list

**Possible Causes**:
1. Scheduled task hasn't run yet (wait until after midnight SGT)
2. No accounts exist for the user
3. Requested dates are in the future

**Solution**: 
- Check logs for calculation errors
- Manually trigger calculation: `dailyAssetCalculationService.calculateForDate(LocalDate.now())`

### Missing Today's Data

**Problem**: Today's asset data is not available

**Cause**: Server was down at midnight or calculation failed

**Solution**: 
- Bootstrap check should have calculated on startup
- Manually trigger if needed
- Check application logs for errors

## Files Created

### New Files (8 files)
- `entities/DailyUserAsset.kt`
- `repositories/dailyAsset/DailyAssetRepository.kt`
- `repositories/dailyAsset/DailyAssetRepositoryImpl.kt`
- `repositories/utils/DailyAssetQueryStore.kt`
- `services/DailyAssetServices/DailyAssetCalculationService.kt`
- `services/DailyAssetServices/DailyAssetService.kt`
- `configs/DailyAssetProperties.kt`
- `bootstrap/DailyAssetBootstrapCheck.kt`

### Modified Files (5 files)
- `src/main/resources/sql/schema.sql` - Added `daily_user_assets` table
- `src/main/resources/application.yml` - Added `daily-asset` configuration
- `grpc_contract/account/v1/account.proto` - Added 3 new RPCs and messages
- `grpc/AccountGrpcService.kt` - Implemented 3 new RPC endpoints
- `grpc/mapper/AccountMapper.kt` - Added proto mapping methods

## Testing

### Manual Testing

1. **Start Services**:
```bash
cd be
docker compose up -d  # Start PostgreSQL, Redis, Kafka
./gradlew bootRun     # Start Spring Boot app
```

2. **Wait for Initial Calculation**: Bootstrap check will calculate today's assets on startup

3. **Test gRPC Calls**: Use a gRPC client (e.g., grpcurl, BloomRPC) to call the endpoints

### Verification Queries

```sql
-- Check today's calculated assets
SELECT * FROM daily_user_assets 
WHERE asset_date = CURRENT_DATE
ORDER BY user_id;

-- Check specific user's asset history
SELECT asset_date, total_asset_value, account_count 
FROM daily_user_assets 
WHERE user_id = 1
ORDER BY asset_date DESC
LIMIT 30;

-- Verify calculation correctness
SELECT 
    u.id AS user_id,
    u.name,
    COALESCE(SUM(a.balance), 0) AS calculated_total,
    dua.total_asset_value AS stored_total
FROM users u
LEFT JOIN accounts a ON a.user_id = u.id
LEFT JOIN daily_user_assets dua ON dua.user_id = u.id AND dua.asset_date = CURRENT_DATE
GROUP BY u.id, u.name, dua.total_asset_value
ORDER BY u.id;
```

## Future Enhancements

Potential improvements:

1. **Asset Breakdown**: Track assets by account type (savings, credit, etc.)
2. **Goal Tracking**: Compare current assets against user-defined goals
3. **Alerts**: Notify users of significant portfolio changes (>5% daily change)
4. **Predictions**: ML-based projection of future asset values
5. **Benchmarking**: Compare user's asset growth vs. market indices
6. **Historical Import**: Allow manual entry of historical asset values
