package sg.flow.services.EventServices

import com.fasterxml.jackson.databind.ObjectMapper
import java.time.Instant
import java.util.Base64
import org.slf4j.LoggerFactory
import org.springframework.kafka.annotation.KafkaListener
import org.springframework.kafka.support.Acknowledgment
import org.springframework.stereotype.Service
import sg.flow.entities.utils.Platform
import sg.flow.entities.utils.SubscriptionEventType
import sg.flow.events.AppStoreNotificationEvent
import sg.flow.repositories.subscription.SubscriptionEventRepository
import sg.flow.repositories.subscription.SubscriptionRepository
import sg.flow.services.SubscriptionServices.SubscriptionEntitlementService
import sg.flow.services.SubscriptionServices.SubscriptionService

@Service
class AppStoreNotificationConsumer(
        private val subscriptionService: SubscriptionService,
        private val subscriptionRepo: SubscriptionRepository,
        private val subscriptionEventRepo: SubscriptionEventRepository,
        private val entitlementService: SubscriptionEntitlementService,
        private val objectMapper: ObjectMapper
) {

    private val logger = LoggerFactory.getLogger(AppStoreNotificationConsumer::class.java)

    @KafkaListener(
            topics = ["\${flow.kafka.topics.appstore-notifications}"],
            groupId = "\${spring.kafka.consumer.group-id}",
            containerFactory = "appStoreKafkaListenerContainerFactory"
    )
    suspend fun handleAppStoreEvent(
            event: AppStoreNotificationEvent,
            acknowledgment: Acknowledgment
    ) {
        try {
            logger.info(
                    "Processing App Store notification: ${event.notificationType}, eventId=${event.eventId}"
            )

            // Extract transaction info from JWS
            val transactionInfo = parseTransactionInfo(event.data.signedTransactionInfo)
            val originalTransactionId = transactionInfo["originalTransactionId"] as? String
            val productId = transactionInfo["productId"] as? String

            // Find user by transaction ID
            val subscription = originalTransactionId?.let { findSubscriptionByTransactionId(it) }

            if (subscription == null) {
                logger.warn("No subscription found for transaction: $originalTransactionId")
                acknowledgment.acknowledge()
                return
            }

            val userId = subscription.userId

            // Handle notification based on type
            when (event.notificationType) {
                "SUBSCRIBED" -> handleSubscribed(userId, event, transactionInfo)
                "DID_RENEW" -> handleRenewal(userId, event, transactionInfo)
                "DID_FAIL_TO_RENEW" -> handleFailedRenewal(userId, event, transactionInfo)
                "DID_CHANGE_RENEWAL_STATUS" ->
                        handleRenewalStatusChange(userId, event, transactionInfo)
                "EXPIRED" -> handleExpiration(userId, event, transactionInfo)
                "REFUND" -> handleRefund(userId, event, transactionInfo)
                "REVOKE" -> handleRevoke(userId, event, transactionInfo)
                "GRACE_PERIOD_EXPIRED" -> handleGracePeriodExpired(userId, event, transactionInfo)
                else -> logger.warn("Unhandled notification type: ${event.notificationType}")
            }

            acknowledgment.acknowledge()
            logger.info("App Store event processed successfully: ${event.eventId}")
        } catch (e: Exception) {
            logger.error("Error processing App Store event: ${event.eventId}", e)
            throw e
        }
    }

    private suspend fun handleSubscribed(
            userId: Int,
            event: AppStoreNotificationEvent,
            transactionInfo: Map<String, Any>
    ) {
        logger.info("Handling SUBSCRIBED for userId=$userId")

        val expiresDateMs = (transactionInfo["expiresDate"] as? Number)?.toLong()
        val expiresDate =
                expiresDateMs?.let { Instant.ofEpochMilli(it) }
                        ?: Instant.now().plusSeconds(30L * 24 * 60 * 60) // 30 days default

        val eventData =
                mapOf(
                        "expiresDate" to expiresDate,
                        "transactionId" to
                                (transactionInfo["originalTransactionId"] as? String ?: ""),
                        "productId" to (transactionInfo["productId"] as? String ?: "")
                )

        subscriptionService.handleSubscriptionEvent(
                userId,
                Platform.IOS,
                SubscriptionEventType.SUBSCRIBED,
                eventData
        )

        entitlementService.invalidateCache(userId, Platform.IOS)
    }

    private suspend fun handleRenewal(
            userId: Int,
            event: AppStoreNotificationEvent,
            transactionInfo: Map<String, Any>
    ) {
        logger.info("Handling DID_RENEW for userId=$userId")

        val expiresDateMs = (transactionInfo["expiresDate"] as? Number)?.toLong()
        val expiresDate =
                expiresDateMs?.let { Instant.ofEpochMilli(it) }
                        ?: Instant.now().plusSeconds(30L * 24 * 60 * 60)

        val eventData = mapOf("expiresDate" to expiresDate)

        subscriptionService.handleSubscriptionEvent(
                userId,
                Platform.IOS,
                SubscriptionEventType.RENEWED,
                eventData
        )

        entitlementService.invalidateCache(userId, Platform.IOS)
    }

    private suspend fun handleFailedRenewal(
            userId: Int,
            event: AppStoreNotificationEvent,
            transactionInfo: Map<String, Any>
    ) {
        logger.info("Handling DID_FAIL_TO_RENEW for userId=$userId")

        val eventData = mapOf("reason" to "PAYMENT_FAILED")

        subscriptionService.handleSubscriptionEvent(
                userId,
                Platform.IOS,
                SubscriptionEventType.EXPIRED,
                eventData
        )

        entitlementService.invalidateCache(userId, Platform.IOS)
    }

    private suspend fun handleRenewalStatusChange(
            userId: Int,
            event: AppStoreNotificationEvent,
            transactionInfo: Map<String, Any>
    ) {
        logger.info("Handling DID_CHANGE_RENEWAL_STATUS for userId=$userId")

        // Check if auto-renew was disabled (user canceled)
        val renewalInfo = parseRenewalInfo(event.data.signedRenewalInfo)
        val autoRenewStatus = renewalInfo["autoRenewStatus"] as? Int

        if (autoRenewStatus == 0) {
            // User turned off auto-renewal
            val eventData = mapOf("reason" to "USER_CANCELED")

            subscriptionService.handleSubscriptionEvent(
                    userId,
                    Platform.IOS,
                    SubscriptionEventType.CANCELED,
                    eventData
            )

            entitlementService.invalidateCache(userId, Platform.IOS)
        }
    }

    private suspend fun handleExpiration(
            userId: Int,
            event: AppStoreNotificationEvent,
            transactionInfo: Map<String, Any>
    ) {
        logger.info("Handling EXPIRED for userId=$userId")

        val eventData = mapOf("reason" to "TRIAL_ENDED")

        subscriptionService.handleSubscriptionEvent(
                userId,
                Platform.IOS,
                SubscriptionEventType.EXPIRED,
                eventData
        )

        entitlementService.invalidateCache(userId, Platform.IOS)
    }

    private suspend fun handleRefund(
            userId: Int,
            event: AppStoreNotificationEvent,
            transactionInfo: Map<String, Any>
    ) {
        logger.info("Handling REFUND for userId=$userId")

        val eventData = mapOf("reason" to "REFUNDED")

        subscriptionService.handleSubscriptionEvent(
                userId,
                Platform.IOS,
                SubscriptionEventType.REFUNDED,
                eventData
        )

        entitlementService.invalidateCache(userId, Platform.IOS)
    }

    private suspend fun handleRevoke(
            userId: Int,
            event: AppStoreNotificationEvent,
            transactionInfo: Map<String, Any>
    ) {
        logger.info("Handling REVOKE for userId=$userId")

        val eventData = mapOf("reason" to "REFUNDED")

        subscriptionService.handleSubscriptionEvent(
                userId,
                Platform.IOS,
                SubscriptionEventType.REFUNDED,
                eventData
        )

        entitlementService.invalidateCache(userId, Platform.IOS)
    }

    private suspend fun handleGracePeriodExpired(
            userId: Int,
            event: AppStoreNotificationEvent,
            transactionInfo: Map<String, Any>
    ) {
        logger.info("Handling GRACE_PERIOD_EXPIRED for userId=$userId")

        // We don't use grace period, so treat as immediate expiration
        val eventData = mapOf("reason" to "PAYMENT_FAILED")

        subscriptionService.handleSubscriptionEvent(
                userId,
                Platform.IOS,
                SubscriptionEventType.EXPIRED,
                eventData
        )

        entitlementService.invalidateCache(userId, Platform.IOS)
    }

    private suspend fun findSubscriptionByTransactionId(
            transactionId: String
    ): sg.flow.entities.UserSubscription? {
        return try {
            subscriptionRepo.findByIosTransactionId(transactionId)
        } catch (e: Exception) {
            logger.error("Failed to find subscription by transaction ID: $transactionId", e)
            null
        }
    }

    private fun parseTransactionInfo(signedTransactionInfo: String): Map<String, Any> {
        return try {
            val parts = signedTransactionInfo.split(".")
            if (parts.size == 3) {
                val payload = String(Base64.getUrlDecoder().decode(parts[1]))
                objectMapper.readValue(payload, Map::class.java) as Map<String, Any>
            } else {
                emptyMap()
            }
        } catch (e: Exception) {
            logger.error("Failed to parse transaction info", e)
            emptyMap()
        }
    }

    private fun parseRenewalInfo(signedRenewalInfo: String?): Map<String, Any> {
        if (signedRenewalInfo == null) return emptyMap()

        return try {
            val parts = signedRenewalInfo.split(".")
            if (parts.size == 3) {
                val payload = String(Base64.getUrlDecoder().decode(parts[1]))
                objectMapper.readValue(payload, Map::class.java) as Map<String, Any>
            } else {
                emptyMap()
            }
        } catch (e: Exception) {
            logger.error("Failed to parse renewal info", e)
            emptyMap()
        }
    }
}
