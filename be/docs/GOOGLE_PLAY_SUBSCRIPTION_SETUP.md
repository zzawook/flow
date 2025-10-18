# Google Play Subscription Setup Guide

## Overview

This guide walks through configuring subscriptions in Google Play Console and setting up Google Cloud Pub/Sub for real-time notifications.

---

## Prerequisites

- Google Play Developer Account ($25 one-time fee)
- App registered in Google Play Console
- Google Cloud account (free tier available)
- Command-line access with `gcloud` CLI installed

---

## Part 1: Google Cloud Pub/Sub Setup

### Step 1.1: Install Google Cloud SDK

```bash
# Download and install (if not already installed)
curl https://sdk.cloud.google.com | bash
exec -l $SHELL

# Initialize gcloud
gcloud init

# Login
gcloud auth login
```

### Step 1.2: Create Google Cloud Project

```bash
# Create project
gcloud projects create flow-subscriptions --name="Flow Subscriptions"

# Set as default project
gcloud config set project flow-subscriptions

# Enable billing (required for Pub/Sub)
# Go to: https://console.cloud.google.com/billing
# Link your billing account to this project
```

### Step 1.3: Enable Required APIs

```bash
# Enable Pub/Sub API
gcloud services enable pubsub.googleapis.com

# Enable Google Play Developer API
gcloud services enable androidpublisher.googleapis.com

# Verify APIs are enabled
gcloud services list --enabled
```

### Step 1.4: Create Service Account

```bash
# Create service account
gcloud iam service-accounts create flow-subscription-service \
    --display-name="Flow Subscription Service" \
    --description="Service account for subscription management"

# Get service account email
SA_EMAIL=$(gcloud iam service-accounts list \
    --filter="displayName:Flow Subscription Service" \
    --format="value(email)")

echo "Service Account: $SA_EMAIL"
# Output: flow-subscription-service@flow-subscriptions.iam.gserviceaccount.com
```

### Step 1.5: Grant Permissions

```bash
# Grant Pub/Sub Subscriber role
gcloud projects add-iam-policy-binding flow-subscriptions \
    --member="serviceAccount:$SA_EMAIL" \
    --role="roles/pubsub.subscriber"

# Grant Android Publisher role (for purchase validation)
gcloud projects add-iam-policy-binding flow-subscriptions \
    --member="serviceAccount:$SA_EMAIL" \
    --role="roles/androidpublisher.subscriptionsViewer"

# Verify permissions
gcloud projects get-iam-policy flow-subscriptions \
    --flatten="bindings[].members" \
    --filter="bindings.members:$SA_EMAIL"
```

### Step 1.6: Create and Download Service Account Key

```bash
# Create key file
gcloud iam service-accounts keys create flow-service-account.json \
    --iam-account=$SA_EMAIL

# IMPORTANT: This file contains sensitive credentials
# Store securely and never commit to git!

# View key file location
ls -l flow-service-account.json
```

### Step 1.7: Create Pub/Sub Topic

```bash
# Create topic for subscription notifications
gcloud pubsub topics create play-subscription-events

# Verify topic created
gcloud pubsub topics list
```

### Step 1.8: Create Push Subscription

```bash
# Create push subscription pointing to your backend
gcloud pubsub subscriptions create flow-backend-subscription \
    --topic=play-subscription-events \
    --push-endpoint=https://flowfinancials.io/api/subscription/google-pubsub \
    --ack-deadline=60

# Verify subscription created
gcloud pubsub subscriptions describe flow-backend-subscription
```

**Expected Output**:
```yaml
ackDeadlineSeconds: 60
name: projects/flow-subscriptions/subscriptions/flow-backend-subscription
pushConfig:
  pushEndpoint: https://flowfinancials.io/api/subscription/google-pubsub
topic: projects/flow-subscriptions/topics/play-subscription-events
```

### Step 1.9: Set Environment Variable

```bash
# Add to your backend environment
export GOOGLE_CLOUD_PROJECT_ID=flow-subscriptions

# For production, add to your deployment config
# e.g., Kubernetes secret, Docker environment, etc.
```

---

## Part 2: Google Play Console Setup

### Step 2.1: Create Subscription Product

1. Go to [Google Play Console](https://play.google.com/console)
2. Select your **Flow** app
3. Navigate to **Monetize → Subscriptions**
4. Click **"Create subscription"**

### Step 2.2: Configure Subscription Details

1. **Product ID**: `monthly_subscription`
   - ⚠️ **Must match** `application.yml`:
     ```yaml
     subscription:
       android:
         product-id: monthly_subscription
     ```
2. **Name**: `Flow Monthly Subscription`
3. **Description**: `Unlimited access to Flow financial management features`

### Step 2.3: Create Base Plan

1. Click **"Add base plan"**
2. **Base plan ID**: `monthly-base-plan`
3. **Billing period**: `Every 1 month`
4. **Price**:
   - Select **Singapore**
   - Enter **SGD 2.99**
   - Click **"Add other regions"** for more countries
5. Click **"Save"**

### Step 2.4: Add Free Trial Offer

1. Within the base plan, click **"Add offer"**
2. **Offer ID**: `free-trial`
3. **Eligibility**: `New customers only`
4. Configure offer phases:
   - **Phase 1 (Trial)**:
     - Duration: `1 Month`
     - Price: `Free`
   - **Phase 2 (Recurring)**:
     - Duration: `Recurring`
     - Price: `SGD 2.99`
5. Click **"Save"**

### Step 2.5: Activate Subscription

1. Click **"Activate"** to make subscription available
2. Status should change to **"Active"**

---

## Part 3: Link Google Cloud to Play Console

### Step 3.1: Enable Cloud Pub/Sub

1. In Play Console, go to **Monetize → Subscriptions**
2. Click **"Settings"** (gear icon)
3. Scroll to **"Real-time developer notifications"**
4. Click **"Enable real-time developer notifications"**

### Step 3.2: Configure Pub/Sub Topic

1. In the **"Topic name"** field, enter:
   ```
   projects/flow-subscriptions/topics/play-subscription-events
   ```
2. Click **"Save changes"**

### Step 3.3: Grant Pub/Sub Publishing Permission

Google Play needs permission to publish to your topic:

```bash
# Add Google Play as publisher
gcloud pubsub topics add-iam-policy-binding play-subscription-events \
    --member=serviceAccount:google-play-developer-notifications@system.gserviceaccount.com \
    --role=roles/pubsub.publisher

# Verify permissions
gcloud pubsub topics get-iam-policy play-subscription-events
```

### Step 3.4: Link Service Account for API Access

1. In Play Console, go to **Settings → API access**
2. Click **"Link Google Cloud project"**
3. Select **"flow-subscriptions"** project
4. Click **"Link"**

### Step 3.5: Grant Permissions to Service Account

1. Still in **API access** page
2. Find your service account: `flow-subscription-service@flow-subscriptions.iam.gserviceaccount.com`
3. Click **"Grant access"**
4. Select permissions:
   - ✅ **View financial data**
   - ✅ **View app information and download bulk reports**
5. Click **"Apply"**

---

## Part 4: Test the Integration

### Step 4.1: Send Test Notification

```bash
# Test Pub/Sub delivery
gcloud pubsub topics publish play-subscription-events \
    --message='{"version":"1.0","packageName":"com.flowfinancials.app","eventTimeMillis":"1234567890","testNotification":{"version":"1.0"}}'

# Check backend logs
# You should see: "Received Google Pub/Sub push notification"
```

### Step 4.2: Test with Real Subscription

1. Create **internal test track** in Play Console
2. Add your email as tester
3. Upload APK/AAB with subscription integration
4. Install app on Android device
5. Purchase subscription (use test payment method)
6. Verify backend receives notification

### Step 4.3: Verify Database

```sql
-- Check subscription was created
SELECT * FROM user_subscriptions 
WHERE platform = 'ANDROID' 
ORDER BY created_at DESC 
LIMIT 5;

-- Check events were logged
SELECT * FROM subscription_events 
WHERE platform = 'ANDROID' 
ORDER BY processed_at DESC 
LIMIT 10;
```

---

## Part 5: Production Deployment

### Step 5.1: Update Backend Configuration

Ensure `application.yml` has correct values:

```yaml
google:
  cloud:
    project-id: flow-subscriptions
    pubsub:
      subscription-id: flow-backend-subscription
      topic-id: play-subscription-events
  play:
    package-name: com.flowfinancials.app

subscription:
  android:
    package-name: com.flowfinancials.app
    product-id: monthly_subscription
```

### Step 5.2: Deploy Service Account Credentials

**Option A: Environment Variable**
```bash
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/flow-service-account.json
```

**Option B: Kubernetes Secret**
```bash
kubectl create secret generic google-credentials \
    --from-file=key.json=flow-service-account.json
```

**Option C: Docker**
```yaml
# docker-compose.yml
services:
  backend:
    environment:
      - GOOGLE_APPLICATION_CREDENTIALS=/app/credentials/service-account.json
    volumes:
      - ./flow-service-account.json:/app/credentials/service-account.json:ro
```

### Step 5.3: Verify HTTPS Endpoint

```bash
# Test endpoint accessibility
curl -X POST https://flowfinancials.io/api/subscription/google-pubsub \
    -H "Content-Type: application/json" \
    -d '{
      "message": {
        "data": "eyJ2ZXJzaW9uIjoiMS4wIn0=",
        "messageId": "test-123",
        "publishTime": "2025-01-01T00:00:00Z"
      },
      "subscription": "projects/flow-subscriptions/subscriptions/flow-backend-subscription"
    }'

# Should return HTTP 200 OK
```

---

## Notification Types Reference

| Type                         | Code | Description                     | Backend Action  |
| ---------------------------- | ---- | ------------------------------- | --------------- |
| SUBSCRIPTION_RECOVERED       | 1    | Payment recovered after failure | Set to ACTIVE   |
| SUBSCRIPTION_RENEWED         | 2    | Subscription renewed            | Extend period   |
| SUBSCRIPTION_CANCELED        | 3    | User canceled                   | Set to CANCELED |
| SUBSCRIPTION_PURCHASED       | 4    | New subscription                | Set to ACTIVE   |
| SUBSCRIPTION_ON_HOLD         | 5    | Payment issue                   | Set to EXPIRED  |
| SUBSCRIPTION_IN_GRACE_PERIOD | 6    | Grace period active             | Set to EXPIRED  |
| SUBSCRIPTION_RESTARTED       | 7    | Subscription restarted          | Set to ACTIVE   |
| SUBSCRIPTION_PAUSED          | 10   | User paused                     | Set to EXPIRED  |
| SUBSCRIPTION_EXPIRED         | 12   | Subscription expired            | Set to EXPIRED  |
| SUBSCRIPTION_REVOKED         | 13   | Refund issued                   | Set to EXPIRED  |

---

## Monitoring & Debugging

### View Pub/Sub Metrics

```bash
# Check message delivery stats
gcloud pubsub subscriptions describe flow-backend-subscription

# View undelivered messages
gcloud pubsub subscriptions pull flow-backend-subscription \
    --limit=10 \
    --auto-ack

# Check topic publish rate
gcloud monitoring dashboards create --config-from-file=pubsub-dashboard.json
```

### View Logs

```bash
# View Pub/Sub delivery logs
gcloud logging read "resource.type=pubsub_subscription AND resource.labels.subscription_id=flow-backend-subscription" \
    --limit 50 \
    --format json

# View backend logs
journalctl -u flow-backend -f
```

### Test Notification Delivery

```bash
# Publish test message
gcloud pubsub topics publish play-subscription-events \
    --message='{
      "version": "1.0",
      "packageName": "com.flowfinancials.app",
      "eventTimeMillis": "1234567890",
      "subscriptionNotification": {
        "version": "1.0",
        "notificationType": 4,
        "purchaseToken": "test-token-123",
        "subscriptionId": "monthly_subscription"
      }
    }'

# Check backend logs
# Should see: "Processing Google Play notification: type=4"
```

---

## Common Issues & Troubleshooting

### Issue 1: Pub/Sub Messages Not Delivered

**Symptoms**: No notifications reaching backend

**Solutions**:
1. Verify push endpoint is publicly accessible (HTTPS required)
2. Check endpoint returns HTTP 200-299
3. Verify service account has `pubsub.subscriber` role
4. Check subscription status:
   ```bash
   gcloud pubsub subscriptions describe flow-backend-subscription
   ```

### Issue 2: Authentication Errors

**Symptoms**: `401 Unauthorized` or `403 Forbidden`

**Solutions**:
1. Verify service account key is correct
2. Check `GOOGLE_APPLICATION_CREDENTIALS` environment variable
3. Ensure service account has required roles
4. Re-download service account key if corrupted

### Issue 3: Topic Not Found

**Symptoms**: Play Console shows "Invalid topic"

**Solutions**:
1. Verify topic exists:
   ```bash
   gcloud pubsub topics list
   ```
2. Ensure correct format: `projects/{PROJECT_ID}/topics/{TOPIC_NAME}`
3. Check Google Play has publisher permission

### Issue 4: Subscription Not Found by Purchase Token

**Symptoms**: Consumer logs "No subscription found for purchase token"

**Solutions**:
1. Verify subscription was created via `LinkPurchase` gRPC call
2. Check `android_purchase_token` was saved correctly
3. Query database:
   ```sql
   SELECT * FROM user_subscriptions WHERE android_purchase_token = 'TOKEN_HERE';
   ```

---

## Security Considerations

### 1. Verify Pub/Sub Push Requests

Google signs Pub/Sub push requests. Verify authenticity:

```kotlin
// In GooglePubSubWebhookController.kt
// TODO: Add JWT verification of push requests
// Verify 'Authorization' header contains valid JWT from Google
```

### 2. Protect Service Account Key

- Never commit `flow-service-account.json` to git
- Add to `.gitignore`:
  ```
  *.json
  !package.json
  ```
- Store in secure vault or secrets manager

### 3. Use HTTPS Only

- Pub/Sub requires HTTPS for push endpoints
- Verify SSL certificate is valid

### 4. Least Privilege

- Service account should only have necessary permissions
- Don't grant owner/editor roles

---

## Production Deployment Checklist

Before going live:

### Google Cloud
- [ ] Project created: `flow-subscriptions`
- [ ] Billing enabled
- [ ] Pub/Sub API enabled
- [ ] Android Publisher API enabled
- [ ] Service account created with correct permissions
- [ ] Service account key downloaded and stored securely
- [ ] Topic created: `play-subscription-events`
- [ ] Push subscription created pointing to production URL
- [ ] Google Play granted publisher permission on topic

### Google Play Console
- [ ] Subscription product created: `monthly_subscription`
- [ ] Base plan configured with SGD 2.99 monthly
- [ ] Free trial offer configured (30 days)
- [ ] Real-time notifications enabled
- [ ] Pub/Sub topic configured
- [ ] Google Cloud project linked
- [ ] Service account granted API access
- [ ] Subscription activated

### Backend
- [ ] `GOOGLE_CLOUD_PROJECT_ID` environment variable set
- [ ] Service account credentials accessible
- [ ] Endpoint `https://flowfinancials.io/api/subscription/google-pubsub` public
- [ ] Endpoint returns HTTP 200 for valid requests
- [ ] Kafka consumers running
- [ ] Database tables created
- [ ] Tested with test notification

### Testing
- [ ] Sent test Pub/Sub message (verified received)
- [ ] Created internal test track
- [ ] Tested subscription purchase with test account
- [ ] Verified notification received and processed
- [ ] Verified subscription state updated in database
- [ ] Tested renewal notification
- [ ] Tested cancellation notification

---

## Alternative: Pull Subscription (Optional)

If you prefer backend to poll for messages instead of receiving push notifications:

### Create Pull Subscription

```bash
gcloud pubsub subscriptions create flow-backend-pull-subscription \
    --topic=play-subscription-events \
    --ack-deadline=60 \
    --message-retention-duration=7d
```

### Backend Implementation

Create a scheduled service to pull messages:

```kotlin
@Service
class GooglePubSubPullListener(
    @Value("\${google.cloud.project-id}") private val projectId: String,
    @Value("\${google.cloud.pubsub.subscription-id}") private val subscriptionId: String
) {
    
    @Scheduled(fixedDelay = 5000) // Poll every 5 seconds
    fun pullMessages() {
        val subscriber = SubscriberStubSettings.newBuilder()
            .setTransportChannelProvider(
                SubscriberStubSettings.defaultGrpcTransportProviderBuilder()
                    .setMaxInboundMessageSize(20 * 1024 * 1024)
                    .build()
            )
            .build()
            .createStub()
        
        val request = PullRequest.newBuilder()
            .setSubscription(ProjectSubscriptionName.format(projectId, subscriptionId))
            .setMaxMessages(10)
            .build()
        
        val response = subscriber.pullCallable().call(request)
        
        response.receivedMessagesList.forEach { message ->
            processMessage(message)
            acknowledgeMessage(message.ackId)
        }
    }
}
```

---

## Testing Scenarios

### Scenario 1: New Subscription Purchase

**Steps**:
1. User purchases subscription in app
2. Google Play charges user
3. Google publishes notification (type=4, SUBSCRIPTION_PURCHASED)
4. Pub/Sub delivers to backend
5. Backend processes and sets subscription to ACTIVE
6. User gains access

**Verify**:
```sql
SELECT * FROM subscription_events 
WHERE event_type = 'SUBSCRIBED' 
ORDER BY processed_at DESC 
LIMIT 1;
```

### Scenario 2: Monthly Renewal

**Steps**:
1. 30 days after initial purchase
2. Google attempts to charge renewal
3. If successful: notification (type=2, SUBSCRIPTION_RENEWED)
4. Backend extends `current_period_end` by 30 days

**Verify**:
```sql
SELECT 
    subscription_status,
    current_period_end,
    auto_renewing
FROM user_subscriptions 
WHERE user_id = ? AND platform = 'ANDROID';
```

### Scenario 3: Payment Failure

**Steps**:
1. Renewal payment fails (insufficient funds, expired card, etc.)
2. Google publishes notification (type=5, SUBSCRIPTION_ON_HOLD)
3. Backend immediately sets status to EXPIRED
4. User loses access

**Verify**:
```sql
SELECT * FROM subscription_events 
WHERE event_type = 'EXPIRED' AND platform = 'ANDROID'
ORDER BY processed_at DESC 
LIMIT 1;
```

### Scenario 4: User Cancellation

**Steps**:
1. User cancels subscription in Google Play
2. Google publishes notification (type=3, SUBSCRIPTION_CANCELED)
3. Backend sets status to CANCELED
4. User retains access until current period ends

**Verify**:
```sql
SELECT 
    subscription_status,
    canceled_at,
    current_period_end 
FROM user_subscriptions 
WHERE user_id = ? AND platform = 'ANDROID';
```

---

## Useful Commands

### Check Subscription Status via API

```bash
# Get access token
gcloud auth application-default print-access-token

# Query subscription
curl -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
  "https://androidpublisher.googleapis.com/androidpublisher/v3/applications/com.flowfinancials.app/purchases/subscriptionsv2/tokens/PURCHASE_TOKEN_HERE"
```

### Monitor Pub/Sub Health

```bash
# Check unacknowledged messages
gcloud pubsub subscriptions describe flow-backend-subscription \
    --format="value(numUndeliveredMessages)"

# View oldest unacknowledged message age
gcloud pubsub subscriptions describe flow-backend-subscription \
    --format="value(oldestUnackedMessageAge)"
```

### Debug Webhook Delivery

```bash
# Enable debug logging
gcloud logging read "resource.type=pubsub_subscription" \
    --limit=20 \
    --format=json \
    --freshness=1h
```

---

## Cost Estimation

### Google Cloud Pub/Sub Pricing

- **First 10 GB/month**: Free
- **Additional data**: $0.06/GB
- **Expected monthly cost**: < $1 for typical app usage

### Google Play Developer API

- **Free tier**: 200 requests/day
- **Additional**: $0.01 per request
- **Expected monthly cost**: Free (within quota)

---

## Rollback Plan

If issues arise in production:

### Disable Real-Time Notifications

```bash
# In Play Console:
# Monetize → Subscriptions → Settings
# Uncheck "Enable real-time developer notifications"
# Click "Save"

# OR delete subscription
gcloud pubsub subscriptions delete flow-backend-subscription
```

### Fallback to Polling

Instead of real-time notifications, poll for subscription status:

```kotlin
@Scheduled(cron = "0 0 2 * * *") // Run daily at 2 AM
suspend fun syncSubscriptions() {
    val users = userRepo.getAllUserIds()
    users.forEach { userId ->
        // Query Google Play API for each subscription
        // Update database accordingly
    }
}
```

---

## Useful Links

- [Google Play Console](https://play.google.com/console)
- [Google Cloud Console](https://console.cloud.google.com)
- [Pub/Sub Documentation](https://cloud.google.com/pubsub/docs)
- [Real-Time Developer Notifications](https://developer.android.com/google/play/billing/rtdn-reference)
- [Google Play Billing](https://developer.android.com/google/play/billing)
- [Android Publisher API](https://developers.google.com/android-publisher)

---

## Support

### Google Play Issues
- Email: googleplay-developer-support@google.com
- Help Center: https://support.google.com/googleplay/android-developer

### Google Cloud Issues
- Support Console: https://console.cloud.google.com/support
- Community: https://stackoverflow.com/questions/tagged/google-cloud-platform

### Backend Issues
- Check logs: `./gradlew bootRun`
- Query events: `SELECT * FROM subscription_events ORDER BY processed_at DESC;`
- Monitor cache: `redis-cli KEYS "subscription:*"`

---

## Next Steps

After setup is complete:

1. ✅ **Test end-to-end flow** with sandbox/test track
2. ✅ **Monitor notifications** for 24 hours
3. ✅ **Set up alerts** for failed webhook deliveries
4. ✅ **Create dashboard** for subscription metrics
5. ✅ **Document** any custom configurations
6. ✅ **Train team** on subscription management

---

## Appendix: Quick Reference

### Key Configuration Values

```yaml
# Backend application.yml
GOOGLE_CLOUD_PROJECT_ID: flow-subscriptions
Pub/Sub Topic: projects/flow-subscriptions/topics/play-subscription-events
Pub/Sub Subscription: flow-backend-subscription
Push Endpoint: https://flowfinancials.io/api/subscription/google-pubsub
Package Name: com.flowfinancials.app
Product ID: monthly_subscription
Base Plan ID: monthly-base-plan
Offer ID: free-trial
```

### Service Account Email

```
flow-subscription-service@flow-subscriptions.iam.gserviceaccount.com
```

### Required Permissions

- `roles/pubsub.subscriber`
- `roles/androidpublisher.subscriptionsViewer`
- Google Play: "View financial data" + "View app information"

