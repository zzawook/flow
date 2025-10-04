# Spending Median Comparison Feature

## Overview

This feature allows users to compare their spending with the median spending of users in their age group. The system automatically calculates and stores spending medians by age group for each month, and provides a gRPC API for users to retrieve this information.

## Architecture

### Components

1. **Database Schema**: `spending_medians_by_age_group` table
2. **Entity**: `SpendingMedianByAgeGroup`
3. **Repository**: `SpendingMedianRepository` with SQL-based median calculation
4. **Scheduled Service**: `SpendingMedianCalculationService` - runs hourly
5. **Business Service**: `SpendingMedianService` - handles user queries
6. **gRPC API**: `GetSpendingMedianForAgeGroup` endpoint in `TransactionHistoryService`
7. **Configuration**: `SpendingMedianProperties` with `application.yml` settings

## Database Schema

```sql
CREATE TABLE spending_medians_by_age_group (
    id BIGSERIAL PRIMARY KEY,
    age_group TEXT NOT NULL,              -- '0s', '10s', '20s', ..., '150s'
    year INT NOT NULL,
    month INT NOT NULL,                   -- 1-12
    median_spending DECIMAL(10,2) NOT NULL,  -- stored as positive value
    user_count INT NOT NULL,
    transaction_count INT NOT NULL,
    calculated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(age_group, year, month)
);
```

## Age Groups

- **Range**: 0s, 10s, 20s, 30s, ..., 150s
- **Calculation**: Based on user's `date_of_birth` in SGT timezone
- **Capping**: Maximum age group is 150s
- Users without `date_of_birth` are excluded from calculations

## Spending Calculation Logic

The median is calculated using the following criteria:

1. **Included Transactions**:
   - `is_included_in_spending_or_income = true`
   - `amount < 0` (negative = spending)
   - Transaction date within the target month

2. **Calculation Method**:
   - Sum all qualifying spending per user for the month
   - Group users by age group
   - Calculate median using PostgreSQL's `PERCENTILE_CONT(0.5)`
   - Store as positive value for better UX

3. **SQL Query** (simplified):
```sql
WITH user_spending AS (
    SELECT 
        age_group,
        user_id,
        ABS(SUM(amount)) AS total_spending
    FROM transaction_histories
    WHERE amount < 0 
      AND is_included_in_spending_or_income = true
      AND EXTRACT(YEAR FROM transaction_date) = ?
      AND EXTRACT(MONTH FROM transaction_date) = ?
    GROUP BY age_group, user_id
)
SELECT 
    age_group,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_spending) AS median_spending,
    COUNT(DISTINCT user_id) AS user_count
FROM user_spending
GROUP BY age_group;
```

## Scheduled Task

### Configuration

```yaml
flow:
  spending-median:
    enabled: true
    backfill-months: 60  # Number of past months to calculate (5 years)
```

### Behavior

- **Schedule**: Every hour at minute 0 (`@Scheduled(cron = "0 0 * * * *")`)
- **Actions**:
  1. Calculates/updates median for current month
  2. Backfills missing historical months (up to `backfill-months` in the past)
- **Performance**: Uses efficient SQL with window functions for large datasets

### Enable/Disable

Set `flow.spending-median.enabled: false` in `application.yml` to disable the scheduled task.

## gRPC API

### Service Definition

```protobuf
service TransactionHistoryService {
  rpc GetSpendingMedianForAgeGroup (GetSpendingMedianRequest) returns (GetSpendingMedianResponse);
}
```

### Request

```protobuf
message GetSpendingMedianRequest {
  optional int32 year = 1;   // If not provided, uses current month (SGT)
  optional int32 month = 2;  // 1-12
}
```

### Response

```protobuf
message GetSpendingMedianResponse {
  string age_group = 1;                    // e.g., "20s", "30s"
  double median_spending = 2;              // Positive value
  int32 year = 3;
  int32 month = 4;
  int32 user_count = 5;                    // Users in this age group
  google.protobuf.Timestamp calculated_at = 6;
}
```

### Usage Examples

#### Get Current Month Median

```kotlin
// Request (empty = current month)
val request = GetSpendingMedianRequest.newBuilder().build()

// Response
val response = client.getSpendingMedianForAgeGroup(request)
// response.ageGroup = "20s"
// response.medianSpending = 1542.50
// response.year = 2025
// response.month = 10
// response.userCount = 237
```

#### Get Specific Month Median

```kotlin
// Request for January 2025
val request = GetSpendingMedianRequest.newBuilder()
    .setYear(2025)
    .setMonth(1)
    .build()

val response = client.getSpendingMedianForAgeGroup(request)
```

### Error Handling

| Status                | Description                                  |
| --------------------- | -------------------------------------------- |
| `UNAUTHENTICATED`     | User not authenticated                       |
| `INVALID_ARGUMENT`    | Invalid year or month                        |
| `FAILED_PRECONDITION` | User has no date of birth                    |
| `NOT_FOUND`           | No median data available for age group/month |

## Client Integration

The mobile app can:

1. Fetch the user's current month spending locally
2. Call `GetSpendingMedianForAgeGroup()` to get median for their age group
3. Compare user's spending vs. median
4. Display insights like:
   - "You spent $1,234 this month. The median for your age group is $1,542."
   - "You're spending 20% less than others in your age group!"

## Testing

### Manual Testing

1. **Start Services**:
```bash
cd be
docker compose up -d  # Start PostgreSQL, Redis, Kafka
./gradlew bootRun     # Start Spring Boot app
```

2. **Wait for Initial Calculation**: The scheduled task will run at the top of the next hour

3. **Test gRPC Call**: Use a gRPC client (e.g., grpcurl, BloomRPC) to call the endpoint

### Verification Queries

```sql
-- Check calculated medians
SELECT * FROM spending_medians_by_age_group 
ORDER BY year DESC, month DESC, age_group;

-- Check user age distribution
SELECT 
    FLOOR(EXTRACT(YEAR FROM AGE(NOW() AT TIME ZONE 'Asia/Singapore', date_of_birth)) / 10) * 10 || 's' AS age_group,
    COUNT(*) as user_count
FROM users 
WHERE date_of_birth IS NOT NULL
GROUP BY age_group
ORDER BY age_group;

-- Check spending for a specific month
SELECT 
    user_id,
    ABS(SUM(amount)) as total_spending
FROM transaction_histories
WHERE EXTRACT(YEAR FROM transaction_date) = 2025
  AND EXTRACT(MONTH FROM transaction_date) = 10
  AND amount < 0
  AND is_included_in_spending_or_income = true
GROUP BY user_id
ORDER BY total_spending DESC;
```

## Performance Considerations

1. **Hourly Execution**: Calculation is expensive but runs only once per hour
2. **Efficient SQL**: Uses window functions and aggregations at database level
3. **Incremental Updates**: Only current month is recalculated; historical data is cached
4. **Indexed Lookups**: Fast retrieval via index on `(age_group, year, month)`

## Troubleshooting

### No Data Returned

**Problem**: API returns `NOT_FOUND`

**Possible Causes**:
1. Scheduled task hasn't run yet (wait for next hour)
2. No users in that age group with transactions for that month
3. Calculation failed (check logs)

**Solution**: Check logs for errors, manually trigger calculation:
```kotlin
@Autowired
lateinit var calculationService: SpendingMedianCalculationService

// Manually calculate for a specific month
calculationService.calculateForMonth(2025, 10)
```

### User Has No Age Group

**Problem**: API returns `FAILED_PRECONDITION`

**Cause**: User's `date_of_birth` is NULL

**Solution**: Ensure users provide date of birth during registration/profile update

## Future Enhancements

Potential improvements:

1. **Category-Based Medians**: Calculate medians per spending category
2. **Percentile Rankings**: Show user's percentile within age group
3. **Trend Analysis**: Compare current vs. previous months
4. **Notifications**: Alert users if spending significantly above median
5. **Regional Comparisons**: Add country/city-based grouping

## Files Modified/Created

### Created Files
- `be/src/main/kotlin/sg/flow/entities/SpendingMedianByAgeGroup.kt`
- `be/src/main/kotlin/sg/flow/repositories/spendingMedian/SpendingMedianRepository.kt`
- `be/src/main/kotlin/sg/flow/repositories/spendingMedian/SpendingMedianRepositoryImpl.kt`
- `be/src/main/kotlin/sg/flow/repositories/utils/SpendingMedianQueryStore.kt`
- `be/src/main/kotlin/sg/flow/services/SpendingMedianServices/SpendingMedianCalculationService.kt`
- `be/src/main/kotlin/sg/flow/services/SpendingMedianServices/SpendingMedianService.kt`
- `be/src/main/kotlin/sg/flow/configs/SpendingMedianProperties.kt`
- `be/docs/SPENDING_MEDIAN_COMPARISON.md`

### Modified Files
- `be/src/main/resources/sql/schema.sql` - Added spending_medians_by_age_group table
- `be/src/main/resources/application.yml` - Added spending-median configuration
- `be/src/main/kotlin/sg/flow/FlowApplication.kt` - Added @EnableScheduling
- `grpc_contract/transaction_history/v1/transaction_history.proto` - Added new RPC and messages
- `be/src/main/kotlin/sg/flow/grpc/TransactionHistoryGrpcService.kt` - Added new endpoint
- `be/src/main/kotlin/sg/flow/grpc/mapper/TransactionHistoryMapper.kt` - Added mapper method

## Configuration Reference

```yaml
flow:
  spending-median:
    enabled: true           # Enable/disable scheduled calculation
    backfill-months: 12     # Number of historical months to backfill
```

## Timezone

All calculations use **Singapore Time (SGT)** (`Asia/Singapore` timezone) to ensure consistency with the application's primary market.

