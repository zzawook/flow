# Apple App Store Subscription Setup Guide

## Overview

This guide walks through configuring subscriptions in Apple App Store Connect for the Flow mobile app.

---

## Prerequisites

- Apple Developer Account ($99/year)
- App registered in App Store Connect
- Access to App Store Connect with Admin or App Manager role

---

## Step 1: Create Auto-Renewable Subscription Product

### 1.1 Access Subscriptions

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click **"My Apps"**
3. Select your **Flow** app
4. Navigate to **Monetization → Subscriptions**

### 1.2 Create Subscription Group

1. Click **"+" button** next to "Subscription Groups"
2. Enter **Reference Name**: `Flow Premium`
3. Click **"Create"**

### 1.3 Create Subscription Product

1. Within the "Flow Premium" group, click **"Create Subscription"**
2. Fill in details:
   - **Reference Name**: `Flow Monthly Subscription`
   - **Product ID**: `com.flowfinancials.subscription.monthly`
     - ⚠️ **Important**: This must match the value in `application.yml`:
       ```yaml
       subscription:
         ios:
           product-id: com.flowfinancials.subscription.monthly
       ```
   - **Subscription Duration**: `1 Month`

### 1.4 Add Subscription Pricing

1. Click **"Subscription Prices"**
2. Click **"Add Subscription Prices"**
3. Select **Singapore** (and any other countries)
4. Set price: **SGD 2.99**
5. Click **"Next"** and **"Save"**

### 1.5 Configure Free Trial Offer

1. Scroll to **"Introductory Offers"**
2. Click **"Create Offer"**
3. Select **"Free Trial"**
4. Fill in:
   - **Duration**: `1 Month`
   - **Eligibility**: `New Subscribers`
   - **Territories**: Select **All Territories** (or specific countries)
5. Click **"Save"**

---

## Step 2: Configure App Store Server Notifications

### 2.1 Set Production URL

1. In App Store Connect, go to your app
2. Navigate to **App Information**
3. Scroll to **"App Store Server Notifications"** section
4. Under **Version 2 Production Server URL**, enter:
   ```
   https://flowfinancials.io/api/subscription/apple
   ```
5. Click **"Save"**

### 2.2 Set Sandbox URL (for Testing)

1. In the same section, under **Version 2 Sandbox Server URL**, enter:
   ```
   https://flowfinancials.io/api/subscription/apple-sandbox
   ```
2. Click **"Save"**

### 2.3 Verify Notification Version

- Ensure **"App Store Server Notifications Version 2"** is selected
- Version 2 provides richer notification data and is recommended

---

## Step 3: Get Shared Secret

### 3.1 Generate Shared Secret

1. In App Store Connect, go to your app
2. Navigate to **Monetization → Subscriptions**
3. Click on **"App-Specific Shared Secret"** (or **"Master Shared Secret"**)
4. Click **"Generate"** if not already created
5. Copy the shared secret (format: `abc123def456...`)

### 3.2 Add to Backend Configuration

1. Open `/home/kjaehyeok21/dev/flow/be/src/main/resources/application.yml`
2. Update:
   ```yaml
   subscription:
     ios:
       shared-secret: "YOUR_SHARED_SECRET_HERE"
   ```
3. **Security Best Practice**: Store in environment variable or Vault:
   ```yaml
   subscription:
     ios:
       shared-secret: ${APPLE_SHARED_SECRET}
   ```

---

## Step 4: Submit for Review

### 4.1 Add Subscription Information

1. Scroll down to **"Subscription Information"**
2. Fill in:
   - **Subscription Display Name**: `Flow Premium`
   - **Description**: `Unlock unlimited access to Flow financial management features`

### 4.2 Add Screenshots

1. Under **"Subscription Review Information"**, add:
   - Screenshot showing subscription features
   - Screenshot of subscription purchase flow

### 4.3 Submit for Review

1. Click **"Submit for Review"**
2. Wait for Apple approval (typically 24-48 hours)

---

## Step 5: Testing with Sandbox

### 5.1 Create Sandbox Tester

1. Go to **Users and Access → Sandbox Testers**
2. Click **"+" button**
3. Fill in:
   - **Email**: Use a unique email (e.g., `test1@flowfinancials.io`)
   - **Password**: Create strong password
   - **Country/Region**: Singapore
4. Click **"Create"**

### 5.2 Test on Device

1. On your test iOS device:
   - Sign out of production App Store
   - **Do NOT sign into sandbox** via Settings
2. Install your app (via TestFlight or Xcode)
3. When prompted for subscription purchase, sign in with sandbox tester account
4. Complete purchase (you won't be charged)
5. Verify backend receives webhook at `/api/subscription/apple-sandbox`

### 5.3 Verify Backend Logs

```bash
# Check backend logs for subscription events
cd /home/kjaehyeok21/dev/flow/be
./gradlew bootRun

# Look for logs like:
# "Received App Store Server Notification"
# "App Store notification published to Kafka: SUBSCRIBED"
# "Processing App Store notification: SUBSCRIBED"
# "Subscription state changed: userId=123, TRIAL → ACTIVE"
```

---

## Step 6: Monitor Notifications

### 6.1 Test Notification

1. In App Store Connect → App Information → App Store Server Notifications
2. Click **"Test"** next to your production URL
3. Check backend logs to verify receipt

### 6.2 View Notification History

1. Apple doesn't provide a dashboard for notification history
2. Monitor your backend logs or build a dashboard using `subscription_events` table

---

## Notification Types Reference

| Notification Type           | Description                        | Backend Action                         |
| --------------------------- | ---------------------------------- | -------------------------------------- |
| `SUBSCRIBED`                | User subscribed or upgraded        | Create/update subscription to ACTIVE   |
| `DID_RENEW`                 | Subscription renewed successfully  | Extend `current_period_end` by 30 days |
| `DID_FAIL_TO_RENEW`         | Renewal payment failed             | Set status to EXPIRED immediately      |
| `DID_CHANGE_RENEWAL_STATUS` | User canceled auto-renewal         | Set status to CANCELED                 |
| `EXPIRED`                   | Subscription expired               | Set status to EXPIRED                  |
| `REFUND`                    | Refund issued                      | Set status to EXPIRED immediately      |
| `REVOKE`                    | Subscription revoked               | Set status to EXPIRED immediately      |
| `GRACE_PERIOD_EXPIRED`      | Grace period ended without payment | Set status to EXPIRED                  |

---

## Common Issues & Troubleshooting

### Issue 1: Webhooks Not Received

**Symptoms**: No webhook events in backend logs

**Solutions**:
1. Verify URL is correct and publicly accessible
2. Check SSL certificate is valid (Apple requires HTTPS)
3. Ensure backend endpoint returns HTTP 200
4. Check firewall/security groups allow Apple's servers

**Apple Webhook IP Ranges** (whitelist these if needed):
- 17.0.0.0/8
- You may need to contact Apple for current IP ranges

### Issue 2: Shared Secret Error

**Symptoms**: Receipt validation fails with "Invalid shared secret"

**Solutions**:
1. Regenerate shared secret in App Store Connect
2. Verify no extra whitespace in configuration
3. Use app-specific shared secret (not master)

### Issue 3: Sandbox vs Production

**Symptoms**: Validation fails with status `21007`

**Solutions**:
- Status `21007` means sandbox receipt sent to production URL
- Backend automatically retries with sandbox URL
- Ensure testing with appropriate environment

---

## Security Considerations

### 1. Validate JWS Signatures

Apple signs all notifications with their private key. You should verify signatures:

```kotlin
// TODO: Implement JWS signature verification
// Use Apple's public key to verify the signature
// Public key available at: https://appleid.apple.com/auth/keys
```

### 2. Protect Shared Secret

- Never commit shared secret to git
- Store in environment variable or Vault
- Rotate periodically

### 3. HTTPS Only

- Apple requires HTTPS for webhooks
- Use valid SSL certificate (Let's Encrypt or commercial)

---

## Production Checklist

Before going live:

- [ ] Subscription product created and approved
- [ ] Free trial offer configured (30 days)
- [ ] Pricing set for all territories (SGD 2.99)
- [ ] Production webhook URL configured
- [ ] Sandbox webhook URL configured for testing
- [ ] Shared secret stored securely
- [ ] Tested with sandbox account
- [ ] Verified webhook reception in logs
- [ ] Verified subscription state changes in database
- [ ] Tested full flow: trial → purchase → renewal

---

## Useful Links

- [App Store Connect](https://appstoreconnect.apple.com)
- [App Store Server Notifications V2 Documentation](https://developer.apple.com/documentation/appstoreservernotifications)
- [Receipt Validation Guide](https://developer.apple.com/documentation/appstorereceipts/verifyreceipt)
- [Subscription Best Practices](https://developer.apple.com/app-store/subscriptions/)

---

## Support

For Apple-specific subscription issues:
- Contact: https://developer.apple.com/contact/
- Forums: https://developer.apple.com/forums/

For backend integration issues:
- Check logs in `/home/kjaehyeok21/dev/flow/be`
- Query `subscription_events` table for audit trail
- Review Redis cache keys: `subscription:{userId}:IOS`

