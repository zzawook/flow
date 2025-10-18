package sg.flow.entities.utils

enum class SubscriptionEventType {
    TRIAL_STARTED, // User started free trial
    SUBSCRIBED, // User purchased subscription (from trial or after expiration)
    RENEWED, // Subscription renewed successfully
    EXPIRED, // Subscription expired (trial ended or payment failed)
    CANCELED, // User canceled subscription
    REFUNDED, // Subscription was refunded
    REACTIVATED // Subscription reactivated after being expired
}
