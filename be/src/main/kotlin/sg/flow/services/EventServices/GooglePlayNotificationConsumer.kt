package sg.flow.services.EventServices

import org.slf4j.LoggerFactory
import org.springframework.kafka.annotation.KafkaListener
import org.springframework.kafka.support.Acknowledgment
import org.springframework.stereotype.Service
import sg.flow.entities.utils.Platform
import sg.flow.entities.utils.SubscriptionEventType
import sg.flow.events.GooglePlayNotificationEvent
import sg.flow.repositories.subscription.SubscriptionRepository
import sg.flow.services.SubscriptionServices.SubscriptionEntitlementService
import sg.flow.services.SubscriptionServices.SubscriptionService

@Service
class GooglePlayNotificationConsumer(
        private val subscriptionService: SubscriptionService,
        private val subscriptionRepo: SubscriptionRepository,
        private val entitlementService: SubscriptionEntitlementService
) {

    private val logger = LoggerFactory.getLogger(GooglePlayNotificationConsumer::class.java)

    @KafkaListener(
            topics = ["\${flow.kafka.topics.googleplay-notifications}"],
            groupId = "\${spring.kafka.consumer.group-id}",
            containerFactory = "googlePlayKafkaListenerContainerFactory"
    )
    suspend fun handleGooglePlayEvent(
            event: GooglePlayNotificationEvent,
            acknowledgment: Acknowledgment
    ) {
        try {
            val notificationType = event.notificationType
            val purchaseToken = event.subscriptionNotification?.purchaseToken

            logger.info(
                    "Processing Google Play notification: type=$notificationType, eventId=${event.eventId}"
            )

            // Find user by purchase token
            val subscription = purchaseToken?.let { findSubscriptionByPurchaseToken(it) }

            if (subscription == null) {
                logger.warn("No subscription found for purchase token: $purchaseToken")
                acknowledgment.acknowledge()
                return
            }

            val userId = subscription.userId

            // Handle notification based on type
            when (notificationType) {
                1 -> handleSubscriptionRecovered(userId, event) // SUBSCRIPTION_RECOVERED
                2 -> handleSubscriptionRenewed(userId, event) // SUBSCRIPTION_RENEWED
                3 -> handleSubscriptionCanceled(userId, event) // SUBSCRIPTION_CANCELED
                4 -> handleSubscriptionPurchased(userId, event) // SUBSCRIPTION_PURCHASED
                5 -> handleSubscriptionOnHold(userId, event) // SUBSCRIPTION_ON_HOLD
                6 -> handleSubscriptionInGracePeriod(userId, event) // SUBSCRIPTION_IN_GRACE_PERIOD
                7 -> handleSubscriptionRestarted(userId, event) // SUBSCRIPTION_RESTARTED
                10 -> handleSubscriptionPaused(userId, event) // SUBSCRIPTION_PAUSED
                12 -> handleSubscriptionExpired(userId, event) // SUBSCRIPTION_EXPIRED
                13 -> handleSubscriptionRevoked(userId, event) // SUBSCRIPTION_REVOKED
                else -> logger.warn("Unhandled notification type: $notificationType")
            }

            acknowledgment.acknowledge()
            logger.info("Google Play event processed successfully: ${event.eventId}")
        } catch (e: Exception) {
            logger.error("Error processing Google Play event: ${event.eventId}", e)
            throw e
        }
    }

    private suspend fun handleSubscriptionRecovered(
            userId: Int,
            event: GooglePlayNotificationEvent
    ) {
        logger.info("Handling SUBSCRIPTION_RECOVERED for userId=$userId")

        // Payment recovered after failure - reactivate subscription
        val eventData = mapOf<String, Any>()

        subscriptionService.handleSubscriptionEvent(
                userId,
                Platform.ANDROID,
                SubscriptionEventType.REACTIVATED,
                eventData
        )

        entitlementService.invalidateCache(userId, Platform.ANDROID)
    }

    private suspend fun handleSubscriptionRenewed(userId: Int, event: GooglePlayNotificationEvent) {
        logger.info("Handling SUBSCRIPTION_RENEWED for userId=$userId")

        // Subscription renewed successfully - extend period
        val eventData = mapOf<String, Any>()

        subscriptionService.handleSubscriptionEvent(
                userId,
                Platform.ANDROID,
                SubscriptionEventType.RENEWED,
                eventData
        )

        entitlementService.invalidateCache(userId, Platform.ANDROID)
    }

    private suspend fun handleSubscriptionCanceled(
            userId: Int,
            event: GooglePlayNotificationEvent
    ) {
        logger.info("Handling SUBSCRIPTION_CANCELED for userId=$userId")

        // User canceled subscription - mark as canceled but keep access until period end
        val eventData = mapOf("reason" to "USER_CANCELED")

        subscriptionService.handleSubscriptionEvent(
                userId,
                Platform.ANDROID,
                SubscriptionEventType.CANCELED,
                eventData
        )

        entitlementService.invalidateCache(userId, Platform.ANDROID)
    }

    private suspend fun handleSubscriptionPurchased(
            userId: Int,
            event: GooglePlayNotificationEvent
    ) {
        logger.info("Handling SUBSCRIPTION_PURCHASED for userId=$userId")

        // New subscription purchased
        val eventData = mapOf<String, Any>()

        subscriptionService.handleSubscriptionEvent(
                userId,
                Platform.ANDROID,
                SubscriptionEventType.SUBSCRIBED,
                eventData
        )

        entitlementService.invalidateCache(userId, Platform.ANDROID)
    }

    private suspend fun handleSubscriptionOnHold(userId: Int, event: GooglePlayNotificationEvent) {
        logger.info("Handling SUBSCRIPTION_ON_HOLD for userId=$userId")

        // Subscription on hold due to payment issues - treat as expired per requirements
        val eventData = mapOf("reason" to "PAYMENT_FAILED")

        subscriptionService.handleSubscriptionEvent(
                userId,
                Platform.ANDROID,
                SubscriptionEventType.EXPIRED,
                eventData
        )

        entitlementService.invalidateCache(userId, Platform.ANDROID)
    }

    private suspend fun handleSubscriptionInGracePeriod(
            userId: Int,
            event: GooglePlayNotificationEvent
    ) {
        logger.info("Handling SUBSCRIPTION_IN_GRACE_PERIOD for userId=$userId")

        // We don't support grace period - treat as expired immediately
        val eventData = mapOf("reason" to "PAYMENT_FAILED")

        subscriptionService.handleSubscriptionEvent(
                userId,
                Platform.ANDROID,
                SubscriptionEventType.EXPIRED,
                eventData
        )

        entitlementService.invalidateCache(userId, Platform.ANDROID)
    }

    private suspend fun handleSubscriptionRestarted(
            userId: Int,
            event: GooglePlayNotificationEvent
    ) {
        logger.info("Handling SUBSCRIPTION_RESTARTED for userId=$userId")

        // Subscription restarted - reactivate
        val eventData = mapOf<String, Any>()

        subscriptionService.handleSubscriptionEvent(
                userId,
                Platform.ANDROID,
                SubscriptionEventType.REACTIVATED,
                eventData
        )

        entitlementService.invalidateCache(userId, Platform.ANDROID)
    }

    private suspend fun handleSubscriptionPaused(userId: Int, event: GooglePlayNotificationEvent) {
        logger.info("Handling SUBSCRIPTION_PAUSED for userId=$userId")

        // Subscription paused - treat as expired
        val eventData = mapOf("reason" to "PAUSED")

        subscriptionService.handleSubscriptionEvent(
                userId,
                Platform.ANDROID,
                SubscriptionEventType.EXPIRED,
                eventData
        )

        entitlementService.invalidateCache(userId, Platform.ANDROID)
    }

    private suspend fun handleSubscriptionExpired(userId: Int, event: GooglePlayNotificationEvent) {
        logger.info("Handling SUBSCRIPTION_EXPIRED for userId=$userId")

        // Subscription expired
        val eventData = mapOf("reason" to "EXPIRED")

        subscriptionService.handleSubscriptionEvent(
                userId,
                Platform.ANDROID,
                SubscriptionEventType.EXPIRED,
                eventData
        )

        entitlementService.invalidateCache(userId, Platform.ANDROID)
    }

    private suspend fun handleSubscriptionRevoked(userId: Int, event: GooglePlayNotificationEvent) {
        logger.info("Handling SUBSCRIPTION_REVOKED for userId=$userId")

        // Subscription revoked (refund) - immediately expire
        val eventData = mapOf("reason" to "REFUNDED")

        subscriptionService.handleSubscriptionEvent(
                userId,
                Platform.ANDROID,
                SubscriptionEventType.REFUNDED,
                eventData
        )

        entitlementService.invalidateCache(userId, Platform.ANDROID)
    }

    private suspend fun findSubscriptionByPurchaseToken(
            purchaseToken: String
    ): sg.flow.entities.UserSubscription? {
        return try {
            subscriptionRepo.findByAndroidPurchaseToken(purchaseToken)
        } catch (e: Exception) {
            logger.error("Failed to find subscription by purchase token: $purchaseToken", e)
            null
        }
    }
}
