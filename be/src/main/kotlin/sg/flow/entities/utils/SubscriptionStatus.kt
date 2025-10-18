package sg.flow.entities.utils

enum class SubscriptionStatus {
    TRIAL, // Free 30-day trial active
    ACTIVE, // Paid subscription active, auto-renewing
    EXPIRED, // Subscription lapsed (payment failed, trial ended, refunded)
    CANCELED // User canceled but access retained until period end
}
