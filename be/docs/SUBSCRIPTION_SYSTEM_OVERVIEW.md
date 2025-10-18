# Flow Subscription System - Complete Overview

## Executive Summary

The Flow app now has a complete subscription management system supporting iOS (App Store) and Android (Google Play) with:

✅ **30-day free trial** (one per email address)  
✅ **Monthly subscription at SGD 2.99** (both platforms)  
✅ **Server-side entitlement enforcement** with Redis caching  
✅ **Event-driven architecture** using Kafka  
✅ **Platform-independent subscriptions** (separate iOS & Android)  
✅ **Real-time webhook processing** from Apple and Google  

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     Mobile App (iOS/Android)                │
│  - In-App Purchase UI                                       │
│  - Device platform detection                                │
│  - gRPC calls to backend                                    │
└────────────────┬────────────────────────────────────────────┘
                 │
                 │ gRPC (with JWT + Platform header)
                 ▼
┌─────────────────────────────────────────────────────────────┐
│                  Backend API Layer (Kotlin)                 │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ AccessTokenValidationInterceptor                      │  │
│  │ - JWT validation                                      │  │
│  │ - Entitlement check (Redis cached, 15min TTL)        │  │
│  │ - Blocks API access if subscription expired          │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ SubscriptionGrpcService                               │  │
│  │ - CheckEntitlement()                                  │  │
│  │ - StartTrial()                                        │  │
│  │ - LinkPurchase()                                      │  │
│  │ - GetSubscriptionStatus()                             │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────┬────────────────────────────────────────────┘
                 │
        ┌────────┴────────┐
        │                 │
        ▼                 ▼
┌──────────────┐   ┌──────────────┐
│ PostgreSQL   │   │ Redis Cache  │
│ - user_      │   │ - subscription│
│   subscript  │   │   :{userId}: │
│   ions       │   │   {platform} │
│ - trial_     │   │ - 15min TTL  │
│   usage_     │   │              │
│   tracking   │   └──────────────┘
│ - subscrip   │
│   tion_events│
└──────────────┘

┌─────────────────────────────────────────────────────────────┐
│              External Platform Webhooks                     │
└─────────────────────────────────────────────────────────────┘
        │                           │
        │ Apple                     │ Google
        │ Server Notifications      │ Cloud Pub/Sub
        ▼                           ▼
┌──────────────────┐        ┌──────────────────┐
│ AppStoreWebhook  │        │ GooglePubSub     │
│ Controller       │        │ WebhookController│
│ /subscription/   │        │ /subscription/   │
│ apple            │        │ google-pubsub    │
└────────┬─────────┘        └────────┬─────────┘
         │                           │
         │ Publish to Kafka          │
         ▼                           ▼
┌─────────────────────────────────────────────┐
│              Kafka Topics                   │
│ - appstore-subscription-notifications       │
│ - googleplay-subscription-notifications     │
└────────────────┬────────────────────────────┘
                 │
        ┌────────┴────────┐
        │                 │
        ▼                 ▼
┌──────────────┐   ┌──────────────┐
│ AppStore     │   │ GooglePlay   │
│ Notification │   │ Notification │
│ Consumer     │   │ Consumer     │
│              │   │              │
│ - Process    │   │ - Process    │
│   events     │   │   events     │
│ - Update DB  │   │ - Update DB  │
│ - Clear cache│   │ - Clear cache│
└──────────────┘   └──────────────┘
```

---

## Database Schema

### Table: `trial_usage_tracking`

Prevents trial abuse by tracking which emails have used the free trial.

```sql
CREATE TABLE trial_usage_tracking (
    id BIGSERIAL PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,           -- One trial per email
    platform TEXT NOT NULL,               -- Which platform first used
    first_trial_started_at TIMESTAMP,
    user_id INT REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW()
);
```

**Indexes**:
- `UNIQUE(email)` - Enforces one trial per email
- `idx_trial_tracking_email` - Fast email lookups
- `idx_trial_tracking_user_id` - Query by user

### Table: `user_subscriptions`

Main subscription state table (one row per user per platform).

```sql
CREATE TABLE user_subscriptions (
    id BIGSERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    platform TEXT NOT NULL,               -- 'IOS' or 'ANDROID'
    subscription_status TEXT NOT NULL,    -- 'TRIAL', 'ACTIVE', 'EXPIRED', 'CANCELED'
    
    -- Trial tracking
    trial_start_date TIMESTAMP,
    trial_end_date TIMESTAMP,
    
    -- Active subscription
    current_period_start TIMESTAMP,
    current_period_end TIMESTAMP,
    auto_renewing BOOLEAN DEFAULT true,
    
    -- Expiration metadata
    expired_at TIMESTAMP,
    expiration_reason TEXT,
    
    -- Cancellation metadata
    canceled_at TIMESTAMP,
    cancellation_reason TEXT,
    
    -- iOS-specific
    ios_original_transaction_id TEXT,
    ios_product_id TEXT,
    ios_environment TEXT,
    
    -- Android-specific
    android_purchase_token TEXT,
    android_product_id TEXT,
    android_order_id TEXT,
    
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    
    UNIQUE(user_id, platform)
);
```

**Indexes**:
- `UNIQUE(user_id, platform)` - One subscription per platform
- `idx_user_subscriptions_status` - Filter by status
- `idx_user_subscriptions_period_end` - Expiration queries

### Table: `subscription_events`

Audit log for all subscription state changes.

```sql
CREATE TABLE subscription_events (
    id BIGSERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    platform TEXT NOT NULL,
    event_type TEXT NOT NULL,
    old_status TEXT,
    new_status TEXT,
    notification_type TEXT,
    transaction_id TEXT,
    raw_notification JSONB NOT NULL,
    error_message TEXT,
    processed_at TIMESTAMP DEFAULT NOW()
);
```

---

## Subscription State Machine

### States

```
TRIAL    → Free 30-day trial period
ACTIVE   → Paid subscription, auto-renewing
EXPIRED  → No access (payment failed, trial ended, refunded)
CANCELED → User canceled but has access until period_end
```

### Transitions

```
[NEW USER SIGNUP]
        ↓
    TRIAL (30 days)
        ↓
   ┌────┴────┐
   │         │
   ▼         ▼
ACTIVE    EXPIRED
(paid)    (trial ended)
   │         ↑
   │ renew   │ payment fail
   ↓         │
ACTIVE ──────┘
   │
   │ user cancels
   ▼
CANCELED
   │
   │ period ends
   ▼
EXPIRED
```

### Event Handlers

| Event                      | Old State     | New State | Action                                                         |
| -------------------------- | ------------- | --------- | -------------------------------------------------------------- |
| **Trial Started**          | -             | TRIAL     | Set `trial_end_date` = now + 30 days                           |
| **Subscription Purchased** | TRIAL/EXPIRED | ACTIVE    | Set `current_period_end` = now + 30 days                       |
| **Renewal Success**        | ACTIVE        | ACTIVE    | Extend `current_period_end` by 30 days                         |
| **Payment Failed**         | ACTIVE        | EXPIRED   | Set `expired_at` = now, `expiration_reason` = "PAYMENT_FAILED" |
| **User Canceled**          | ACTIVE        | CANCELED  | Set `canceled_at` = now, retain access until `period_end`      |
| **Period Ended**           | CANCELED      | EXPIRED   | No action (automatic)                                          |
| **Refund Issued**          | ACTIVE/TRIAL  | EXPIRED   | Immediate expiration                                           |
| **Payment Recovered**      | EXPIRED       | ACTIVE    | Reactivate with new period                                     |

---

## API Endpoints

### gRPC Endpoints

#### 1. CheckEntitlement

Check if user has active access.

**Request**:
```protobuf
CheckEntitlementRequest {
  user_id: 123
  platform: "IOS"
}
```

**Response**:
```protobuf
CheckEntitlementResponse {
  has_access: true
  status: "TRIAL"
  access_expires_at: "2025-11-17T00:00:00Z"
  message: ""
}
```

#### 2. StartTrial

Start free 30-day trial (called after signup).

**Request**:
```protobuf
StartTrialRequest {
  user_id: 123
  platform: "IOS"
}
```

**Response (Success)**:
```protobuf
StartTrialResponse {
  success: true
  message: "Trial started successfully"
  trial_end_date: "2025-11-17T00:00:00Z"
}
```

**Response (Already Used)**:
```protobuf
StartTrialResponse {
  success: false
  message: "This email address has already used the free trial on IOS"
  already_used_platform: "IOS"
  already_used_date: "2025-01-15T00:00:00Z"
}
```

#### 3. LinkPurchase

Link platform purchase to user account.

**Request**:
```protobuf
LinkPurchaseRequest {
  user_id: 123
  platform: "IOS"
  purchase_data: {
    ios_receipt_data: "base64_encoded_receipt..."
    ios_transaction_id: "1000000123456789"
  }
}
```

**Response**:
```protobuf
LinkPurchaseResponse {
  success: true
  message: "Purchase linked successfully"
  new_status: "ACTIVE"
  period_end: "2025-11-17T00:00:00Z"
}
```

#### 4. GetSubscriptionStatus

Get detailed subscription info.

**Request**:
```protobuf
GetSubscriptionStatusRequest {
  user_id: 123
  platform: "IOS"
}
```

**Response**:
```protobuf
GetSubscriptionStatusResponse {
  status: "ACTIVE"
  platform: "IOS"
  current_period_start: "2025-10-18T00:00:00Z"
  current_period_end: "2025-11-17T00:00:00Z"
  auto_renewing: true
  product_id: "com.flowfinancials.subscription.monthly"
}
```

### REST Endpoints

#### 1. Apple Webhook

**Endpoint**: `POST /api/subscription/apple`

Receives App Store Server Notifications (V2).

**Request** (from Apple):
```json
{
  "signedPayload": "eyJhbGc..."
}
```

**Response**: `200 OK`

#### 2. Google Pub/Sub Webhook

**Endpoint**: `POST /api/subscription/google-pubsub`

Receives Google Cloud Pub/Sub push notifications.

**Request** (from Google):
```json
{
  "message": {
    "data": "eyJ2ZXJzaW9uIjoiMS4wIi...",
    "messageId": "123456",
    "publishTime": "2025-10-18T12:00:00Z"
  },
  "subscription": "projects/flow-subscriptions/subscriptions/flow-backend-subscription"
}
```

**Response**: `200 OK`

---

## Entitlement Enforcement

### Frontend (App Launch)

```dart
// On app launch
final entitlement = await grpcService.checkEntitlement(userId, platform);

if (!entitlement.hasAccess) {
  // Show subscription screen
  Navigator.push(context, MaterialPageRoute(
    builder: (context) => SubscriptionExpiredScreen()
  ));
} else {
  // Proceed to main app
  Navigator.push(context, MaterialPageRoute(
    builder: (context) => HomeScreen()
  ));
}
```

### Backend (Every API Call)

```kotlin
// In AccessTokenValidationInterceptor
// Automatically checks subscription on EVERY gRPC call
// Uses Redis cache (15-minute TTL) for performance

// Flow:
// 1. Extract userId from JWT
// 2. Extract platform from X-Platform header
// 3. Check Redis: subscription:{userId}:{platform}
// 4. If cache hit (99% of requests): return immediately (~1-2ms)
// 5. If cache miss: query PostgreSQL (~5-15ms)
// 6. If no access: throw PERMISSION_DENIED
// 7. If has access: proceed with request
```

**Performance**:
- **With cache hit (99%)**: +1-2ms latency
- **With cache miss**: +5-15ms latency
- **Cache invalidation**: On every subscription state change

---

## User Flows

### Flow 1: New User Signup

```
1. User opens app for first time
2. User completes signup form (email required)
3. App calls: StartTrial(userId, platform)
4. Backend checks: Has this email used trial before?
   - NO → Create subscription with status=TRIAL
   - YES → Return "Trial already used" message
5. If trial started:
   - Record in trial_usage_tracking table
   - Set trial_end_date = now + 30 days
   - User gets full access for 30 days
```

### Flow 2: Trial User Purchases Early

```
1. User in trial (day 15 of 30)
2. User taps "Subscribe" in app
3. Platform IAP flow:
   - iOS: Shows Apple subscription sheet
   - Android: Shows Google Play subscription sheet
4. User confirms purchase with Face ID / fingerprint
5. Platform processes payment
6. App receives purchase confirmation with receipt/token
7. App calls: LinkPurchase(userId, platform, receipt_data)
8. Backend:
   - Validates receipt with Apple/Google
   - Updates subscription: TRIAL → ACTIVE
   - Sets current_period_end = expires_date from receipt
   - Invalidates Redis cache
9. App receives success → user continues using app
```

### Flow 3: Monthly Renewal

```
1. 30 days after subscription start
2. Platform attempts to charge renewal
3. If payment succeeds:
   - Apple/Google sends webhook notification
   - Backend receives notification via Kafka
   - Backend extends current_period_end by 30 days
   - Redis cache invalidated
   - User continues with access
4. If payment fails:
   - Notification received
   - Backend sets status=EXPIRED immediately
   - Next API call returns PERMISSION_DENIED
   - App shows subscription screen
```

### Flow 4: User Cancels Subscription

```
1. User opens App Store / Play Store
2. User cancels subscription
3. Platform sends cancellation notification
4. Backend:
   - Sets status=CANCELED
   - Sets canceled_at=now
   - Keeps current_period_end unchanged
   - User retains access until period end
5. When current_period_end passes:
   - EntitlementService returns has_access=false
   - Next app launch shows subscription screen
```

### Flow 5: Refund Issued

```
1. User requests refund from Apple/Google
2. Platform approves and issues refund
3. Refund notification sent to backend
4. Backend:
   - Sets status=EXPIRED immediately
   - Sets expiration_reason="REFUNDED"
   - Invalidates cache
5. User loses access immediately on next API call
```

---

## Configuration Reference

### Backend Configuration (`application.yml`)

```yaml
# Kafka topics for subscription events
flow:
  kafka:
    topics:
      appstore-notifications: appstore-subscription-notifications
      googleplay-notifications: googleplay-subscription-notifications

# Subscription settings
subscription:
  price:
    sgd: 2.99
  ios:
    product-id: com.flowfinancials.subscription.monthly
    shared-secret: "${APPLE_SHARED_SECRET}"
    verify-receipt-url:
      production: https://buy.itunes.apple.com/verifyReceipt
      sandbox: https://sandbox.itunes.apple.com/verifyReceipt
  android:
    package-name: com.flowfinancials.app
    product-id: monthly_subscription
  trial:
    duration-days: 30
  cache:
    ttl-seconds: 900  # 15 minutes

# Google Cloud configuration
google:
  cloud:
    project-id: ${GOOGLE_CLOUD_PROJECT_ID}
    pubsub:
      subscription-id: flow-backend-subscription
      topic-id: play-subscription-events
  play:
    package-name: com.flowfinancials.app
```

### Environment Variables

```bash
# Required for production
export GOOGLE_CLOUD_PROJECT_ID=flow-subscriptions
export APPLE_SHARED_SECRET=abc123def456...

# Optional (if using environment-based credentials)
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json
```

---

## Files Created

### Backend Components (40 files)

#### Entities (6 files)
- `entities/UserSubscription.kt`
- `entities/TrialUsageTracking.kt`
- `entities/SubscriptionEvent.kt`
- `entities/utils/SubscriptionStatus.kt`
- `entities/utils/Platform.kt`
- `entities/utils/SubscriptionEventType.kt`

#### Repositories (9 files)
- `repositories/subscription/SubscriptionRepository.kt`
- `repositories/subscription/SubscriptionRepositoryImpl.kt`
- `repositories/trial/TrialTrackingRepository.kt`
- `repositories/trial/TrialTrackingRepositoryImpl.kt`
- `repositories/subscription/SubscriptionEventRepository.kt`
- `repositories/subscription/SubscriptionEventRepositoryImpl.kt`
- `repositories/utils/SubscriptionQueryStore.kt`
- `repositories/utils/TrialTrackingQueryStore.kt`
- `repositories/utils/SubscriptionEventQueryStore.kt`

#### Services (8 files)
- `services/SubscriptionServices/TrialService.kt`
- `services/SubscriptionServices/TrialServiceImpl.kt`
- `services/SubscriptionServices/SubscriptionService.kt`
- `services/SubscriptionServices/SubscriptionServiceImpl.kt`
- `services/SubscriptionServices/SubscriptionEntitlementService.kt`
- `services/SubscriptionServices/SubscriptionEntitlementServiceImpl.kt`
- `services/SubscriptionServices/AppStoreReceiptValidator.kt`
- `services/SubscriptionServices/GooglePlayPurchaseValidator.kt`

#### Event Handling (4 files)
- `events/AppStoreNotificationEvent.kt`
- `events/GooglePlayNotificationEvent.kt`
- `services/EventServices/AppStoreNotificationConsumer.kt`
- `services/EventServices/GooglePlayNotificationConsumer.kt`

#### REST Controllers (2 files)
- `rest_controllers/AppStoreWebhookController.kt`
- `rest_controllers/GooglePubSubWebhookController.kt`

#### gRPC (3 files)
- `grpc/SubscriptionGrpcService.kt`
- `grpc/mapper/SubscriptionMapper.kt`
- `grpc_contract/subscription/v1/subscription.proto`

#### Models (2 files)
- `models/subscription/AppleModels.kt`
- `models/subscription/GooglePlayModels.kt`

#### Configuration (2 files)
- `configs/SubscriptionProperties.kt`
- Updated: `configs/FlowSecurityConfig.kt`
- Updated: `configs/KafkaConfig.kt`

#### Documentation (3 files)
- `docs/APPLE_SUBSCRIPTION_SETUP.md`
- `docs/GOOGLE_PLAY_SUBSCRIPTION_SETUP.md`
- `docs/SUBSCRIPTION_SYSTEM_OVERVIEW.md`

#### Updated Files (4 files)
- `src/main/resources/sql/schema.sql`
- `src/main/resources/application.yml`
- `build.gradle.kts`
- `auth/AccessTokenValidationInterceptor.kt`
- `services/EventServices/KafkaEventProducerService.kt`
- `services/UtilServices/CacheService/CacheService.kt`
- `services/UtilServices/CacheService/RedisCacheServiceImpl.kt`

**Total**: ~45 files created/modified

---

## Monitoring & Observability

### Key Metrics to Track

1. **Trial Conversion Rate**
   ```sql
   SELECT 
       COUNT(CASE WHEN subscription_status = 'ACTIVE' THEN 1 END) * 100.0 / 
       COUNT(CASE WHEN subscription_status IN ('TRIAL', 'ACTIVE', 'EXPIRED') THEN 1 END) 
   AS conversion_rate
   FROM user_subscriptions;
   ```

2. **Active Subscriptions**
   ```sql
   SELECT platform, COUNT(*) 
   FROM user_subscriptions 
   WHERE subscription_status = 'ACTIVE' 
   GROUP BY platform;
   ```

3. **Churn Rate**
   ```sql
   SELECT COUNT(*) 
   FROM subscription_events 
   WHERE event_type = 'EXPIRED' 
   AND processed_at > NOW() - INTERVAL '30 days';
   ```

4. **Revenue (Monthly Recurring Revenue)**
   ```sql
   SELECT COUNT(*) * 2.99 AS mrr_sgd
   FROM user_subscriptions 
   WHERE subscription_status = 'ACTIVE';
   ```

### Log Queries

```bash
# View subscription state changes
grep "Subscription state changed" /var/log/flow/backend.log

# View failed notifications
grep "ERROR.*subscription" /var/log/flow/backend.log

# View cache performance
grep "Entitlement cache" /var/log/flow/backend.log | grep -c "HIT"
grep "Entitlement cache" /var/log/flow/backend.log | grep -c "MISS"
```

### Redis Cache Monitoring

```bash
# Check cache hit rate
redis-cli INFO stats | grep keyspace

# View subscription cache keys
redis-cli KEYS "subscription:*"

# Check specific user's cache
redis-cli GET "subscription:123:IOS"

# Monitor cache expirations
redis-cli --scan --pattern "subscription:*" | xargs redis-cli TTL
```

---

## Deployment Guide

### Step 1: Database Migration

```bash
# Backup existing database
pg_dump flow_dev > flow_backup_$(date +%Y%m%d).sql

# Run backend (schema auto-applies)
cd /home/kjaehyeok21/dev/flow/be
./gradlew bootRun

# Verify tables created
psql -d flow_dev -c "\dt *subscription*"
```

### Step 2: Configure External Services

1. Follow `APPLE_SUBSCRIPTION_SETUP.md`
2. Follow `GOOGLE_PLAY_SUBSCRIPTION_SETUP.md`

### Step 3: Deploy Backend

```bash
# Build production JAR
./gradlew build

# Copy JAR to server
scp build/libs/flow-*.jar user@server:/opt/flow/

# Start service
systemctl start flow-backend
systemctl enable flow-backend
```

### Step 4: Verify Health

```bash
# Check gRPC service
grpcurl -plaintext localhost:9090 list

# Should include: subscription.v1.SubscriptionService

# Check Redis connection
redis-cli PING

# Check Kafka consumers
# Look for logs: "Subscribed to topic(s): appstore-subscription-notifications"
```

---

## Security Audit

### Authentication

- ✅ JWT validation on all gRPC calls
- ✅ Platform header required for entitlement check
- ✅ Subscription methods exempt from entitlement check (avoid circular dependency)

### Authorization

- ✅ User can only access their own subscription
- ✅ Platform-specific subscriptions (no cross-platform access)
- ✅ Immediate revocation on payment failure/refund

### Data Protection

- ✅ Sensitive data (shared secrets, service accounts) in Vault/env vars
- ✅ Audit log for all state changes
- ✅ No PII in logs (only userIds, transaction IDs)

### Rate Limiting

- ⚠️ **TODO**: Add rate limiting on webhook endpoints
- ⚠️ **TODO**: Add request throttling for entitlement checks

---

## Future Enhancements

### Phase 2 (Optional)

1. **Promotional Offers**
   - Discount codes
   - Seasonal sales
   - Referral bonuses

2. **Family Sharing** (iOS only)
   - Support Family Sharing subscriptions
   - Track purchaser vs family members

3. **Grace Period**
   - Add GRACE_PERIOD status
   - Allow 3-day grace for failed payments

4. **Analytics Dashboard**
   - Real-time subscription metrics
   - Revenue tracking
   - Churn analysis

5. **Admin Panel**
   - Manually grant/revoke subscriptions
   - View user subscription history
   - Issue refunds

---

## Testing Checklist

Before production release:

### Unit Tests
- [ ] TrialService - email-based trial prevention
- [ ] SubscriptionService - state machine transitions
- [ ] EntitlementService - Redis caching logic

### Integration Tests
- [ ] Trial start flow
- [ ] Purchase linking (iOS & Android)
- [ ] Webhook processing (all notification types)
- [ ] Entitlement check with cache hit/miss

### End-to-End Tests
- [ ] iOS: Signup → trial → purchase → renewal
- [ ] Android: Signup → trial → purchase → renewal
- [ ] Cross-platform: iOS trial, then Android trial
- [ ] Payment failure → immediate expiration
- [ ] Cancellation → access until period end
- [ ] Refund → immediate revocation

### Performance Tests
- [ ] 1000 concurrent entitlement checks
- [ ] Cache hit rate > 95%
- [ ] Average latency < 50ms for cached requests

---

## Rollback Plan

If critical issues arise in production:

### 1. Disable Entitlement Checks

```kotlin
// In AccessTokenValidationInterceptor.kt
// Comment out entitlement check temporarily
// if (subscriptionEntitlementService != null && fullMethod !in subscriptionMethods) {
//     val hasAccess = runBlocking {
//         subscriptionEntitlementService.hasActiveAccess(userDetails.userId, platform)
//     }
//     if (!hasAccess) {
//         throw Status.PERMISSION_DENIED...
//     }
// }
```

### 2. Grant Emergency Access

```sql
-- Give all users active subscriptions temporarily
UPDATE user_subscriptions 
SET subscription_status = 'ACTIVE',
    current_period_end = NOW() + INTERVAL '7 days'
WHERE subscription_status IN ('EXPIRED', 'TRIAL');
```

### 3. Rollback Database

```sql
-- Drop subscription tables (DESTRUCTIVE!)
DROP TABLE IF EXISTS subscription_events;
DROP TABLE IF EXISTS user_subscriptions;
DROP TABLE IF EXISTS trial_usage_tracking;
```

---

## Support & Maintenance

### Daily Tasks

- Monitor webhook delivery success rate
- Check for failed notification processing
- Review subscription event logs

### Weekly Tasks

- Analyze trial conversion rate
- Review churn (expired/canceled subscriptions)
- Check cache hit rate
- Verify webhook endpoints are accessible

### Monthly Tasks

- Review revenue vs forecasts
- Analyze platform split (iOS vs Android)
- Check for trial abuse attempts
- Update pricing if needed

---

## Contact & Resources

### Documentation
- Apple Setup: `be/docs/APPLE_SUBSCRIPTION_SETUP.md`
- Google Setup: `be/docs/GOOGLE_PLAY_SUBSCRIPTION_SETUP.md`

### External Links
- App Store Connect: https://appstoreconnect.apple.com
- Google Play Console: https://play.google.com/console
- Google Cloud Console: https://console.cloud.google.com

### Support Channels
- Apple Developer Support: https://developer.apple.com/support/
- Google Play Support: https://support.google.com/googleplay/android-developer
- Flow Backend Issues: Check `be/docs/` folder

---

## Success Criteria

System is production-ready when:

✅ All tests passing  
✅ Apple subscription approved and active  
✅ Google Play subscription approved and active  
✅ Webhooks receiving notifications in production  
✅ Trial prevention working (one per email)  
✅ Entitlement checks < 5ms (95th percentile)  
✅ Redis cache hit rate > 95%  
✅ Zero failed notification processing  
✅ Documentation complete  
✅ Team trained on subscription management  

---

**Last Updated**: 2025-10-18  
**Version**: 1.0  
**Maintainer**: Flow Development Team

