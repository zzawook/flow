package sg.flow.services.SubscriptionServices

import java.time.Instant
import java.time.temporal.ChronoUnit
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import sg.flow.entities.SubscriptionEvent
import sg.flow.entities.UserSubscription
import sg.flow.entities.utils.Platform
import sg.flow.entities.utils.SubscriptionEventType
import sg.flow.entities.utils.SubscriptionStatus
import sg.flow.repositories.subscription.SubscriptionEventRepository
import sg.flow.repositories.subscription.SubscriptionRepository
import sg.flow.repositories.user.UserRepository

@Service
class SubscriptionServiceImpl(
        private val subscriptionRepo: SubscriptionRepository,
        private val subscriptionEventRepo: SubscriptionEventRepository,
        private val userRepo: UserRepository,
        private val trialService: TrialService,
        private val entitlementService: SubscriptionEntitlementService,
        @Value("\${subscription.trial.duration-days:30}") private val trialDurationDays: Long
) : SubscriptionService {

    private val logger = LoggerFactory.getLogger(SubscriptionServiceImpl::class.java)

    override suspend fun startTrial(userId: Int, platform: Platform): TrialStartResult {
        logger.info("Starting trial for userId=$userId, platform=$platform")

        // Get user email
        val user =
                userRepo.findById(userId.toLong())
                        ?: return TrialStartResult.AlreadySubscribed("User not found")

        val email = user.email

        // Check if this email has ever used trial
        val eligibility = trialService.canStartTrial(email)
        if (eligibility is TrialEligibilityResult.AlreadyUsed) {
            return TrialStartResult.AlreadyUsed(
                    message =
                            "This email address has already used the free trial on ${eligibility.platform}",
                    firstUsedDate = eligibility.firstUsedDate,
                    platform = eligibility.platform
            )
        }

        // Check if user already has subscription on this platform
        val existingSubscription = subscriptionRepo.findByUserIdAndPlatform(userId, platform)
        if (existingSubscription != null) {
            return TrialStartResult.AlreadySubscribed("Already have subscription on this platform")
        }

        // Create trial subscription
        val now = Instant.now()
        val trialEndDate = now.plus(trialDurationDays, ChronoUnit.DAYS)

        val subscription =
                UserSubscription(
                        id = null,
                        userId = userId,
                        platform = platform,
                        subscriptionStatus = SubscriptionStatus.TRIAL,
                        trialStartDate = now,
                        trialEndDate = trialEndDate,
                        currentPeriodStart = null,
                        currentPeriodEnd = null,
                        autoRenewing = true,
                        expiredAt = null,
                        expirationReason = null,
                        canceledAt = null,
                        cancellationReason = null,
                        iosOriginalTransactionId = null,
                        iosProductId = null,
                        iosEnvironment = null,
                        androidPurchaseToken = null,
                        androidProductId = null,
                        androidOrderId = null
                )

        val saved = subscriptionRepo.save(subscription)

        // Record trial usage
        trialService.recordTrialUsage(userId, platform, email)

        // Log event
        logEvent(
                userId,
                platform,
                SubscriptionEventType.TRIAL_STARTED,
                null,
                SubscriptionStatus.TRIAL,
                "{}"
        )

        // Invalidate cache
        entitlementService.invalidateCache(userId, platform)

        logger.info(
                "Trial started successfully: userId=$userId, platform=$platform, expiresAt=$trialEndDate"
        )

        return TrialStartResult.Success(trialEndDate)
    }

    override suspend fun linkPurchase(
            userId: Int,
            platform: Platform,
            purchaseData: PurchaseData
    ): LinkPurchaseResult {
        logger.info("Linking purchase for userId=$userId, platform=$platform")

        val existingSubscription = subscriptionRepo.findByUserIdAndPlatform(userId, platform)

        val now = Instant.now()
        val periodEnd = purchaseData.expiresDate

        val subscription =
                if (existingSubscription != null) {
                    // Update existing subscription
                    val oldStatus = existingSubscription.subscriptionStatus

                    existingSubscription.copy(
                            subscriptionStatus = SubscriptionStatus.ACTIVE,
                            currentPeriodStart = now,
                            currentPeriodEnd = periodEnd,
                            autoRenewing = true,
                            expiredAt = null,
                            expirationReason = null,
                            iosOriginalTransactionId = purchaseData.originalTransactionId
                                            ?: existingSubscription.iosOriginalTransactionId,
                            iosProductId =
                                    if (platform == Platform.IOS) purchaseData.productId
                                    else existingSubscription.iosProductId,
                            androidPurchaseToken = purchaseData.purchaseToken
                                            ?: existingSubscription.androidPurchaseToken,
                            androidProductId =
                                    if (platform == Platform.ANDROID) purchaseData.productId
                                    else existingSubscription.androidProductId,
                            androidOrderId = purchaseData.orderId
                                            ?: existingSubscription.androidOrderId,
                            updatedAt = now
                    )
                } else {
                    // Create new subscription
                    UserSubscription(
                            id = null,
                            userId = userId,
                            platform = platform,
                            subscriptionStatus = SubscriptionStatus.ACTIVE,
                            trialStartDate = null,
                            trialEndDate = null,
                            currentPeriodStart = now,
                            currentPeriodEnd = periodEnd,
                            autoRenewing = true,
                            expiredAt = null,
                            expirationReason = null,
                            canceledAt = null,
                            cancellationReason = null,
                            iosOriginalTransactionId =
                                    if (platform == Platform.IOS) purchaseData.originalTransactionId
                                    else null,
                            iosProductId =
                                    if (platform == Platform.IOS) purchaseData.productId else null,
                            iosEnvironment = null,
                            androidPurchaseToken =
                                    if (platform == Platform.ANDROID) purchaseData.purchaseToken
                                    else null,
                            androidProductId =
                                    if (platform == Platform.ANDROID) purchaseData.productId
                                    else null,
                            androidOrderId =
                                    if (platform == Platform.ANDROID) purchaseData.orderId else null
                    )
                }

        val saved =
                if (existingSubscription != null) {
                    subscriptionRepo.updateSubscription(subscription)
                    subscription
                } else {
                    subscriptionRepo.save(subscription)
                }

        // Log event
        val eventType =
                if (existingSubscription?.subscriptionStatus == SubscriptionStatus.TRIAL) {
                    SubscriptionEventType.SUBSCRIBED
                } else if (existingSubscription?.subscriptionStatus == SubscriptionStatus.EXPIRED) {
                    SubscriptionEventType.REACTIVATED
                } else {
                    SubscriptionEventType.SUBSCRIBED
                }

        logEvent(
                userId,
                platform,
                eventType,
                existingSubscription?.subscriptionStatus,
                SubscriptionStatus.ACTIVE,
                "{}"
        )

        // Invalidate cache
        entitlementService.invalidateCache(userId, platform)

        logger.info(
                "Purchase linked successfully: userId=$userId, platform=$platform, periodEnd=$periodEnd"
        )

        return LinkPurchaseResult.Success(saved)
    }

    override suspend fun handleSubscriptionEvent(
            userId: Int,
            platform: Platform,
            eventType: SubscriptionEventType,
            eventData: Map<String, Any>
    ) {
        logger.info(
                "Handling subscription event: userId=$userId, platform=$platform, eventType=$eventType"
        )

        val subscription =
                subscriptionRepo.findByUserIdAndPlatform(userId, platform)
                        ?: run {
                            logger.warn(
                                    "No subscription found for userId=$userId, platform=$platform"
                            )
                            return
                        }

        val oldStatus = subscription.subscriptionStatus
        val updated =
                when (eventType) {
                    SubscriptionEventType.RENEWED -> handleRenewal(subscription, eventData)
                    SubscriptionEventType.EXPIRED -> handleExpiration(subscription, eventData)
                    SubscriptionEventType.CANCELED -> handleCancellation(subscription, eventData)
                    SubscriptionEventType.REFUNDED -> handleRefund(subscription, eventData)
                    else -> subscription
                }

        if (updated.subscriptionStatus != oldStatus) {
            subscriptionRepo.updateSubscription(updated)
            logEvent(userId, platform, eventType, oldStatus, updated.subscriptionStatus, "{}")
            entitlementService.invalidateCache(userId, platform)

            logger.info(
                    "Subscription state changed: userId=$userId, $oldStatus → ${updated.subscriptionStatus}"
            )
        }
    }

    override suspend fun getSubscriptionStatus(userId: Int, platform: Platform): UserSubscription? {
        return subscriptionRepo.findByUserIdAndPlatform(userId, platform)
    }

    private fun handleRenewal(
            subscription: UserSubscription,
            eventData: Map<String, Any>
    ): UserSubscription {
        val newPeriodEnd =
                eventData["expiresDate"] as? Instant
                        ?: subscription.currentPeriodEnd?.plus(30, ChronoUnit.DAYS)
                                ?: Instant.now().plus(30, ChronoUnit.DAYS)

        return subscription.copy(
                subscriptionStatus = SubscriptionStatus.ACTIVE,
                currentPeriodStart = subscription.currentPeriodEnd ?: Instant.now(),
                currentPeriodEnd = newPeriodEnd,
                autoRenewing = true,
                expiredAt = null,
                expirationReason = null
        )
    }

    private fun handleExpiration(
            subscription: UserSubscription,
            eventData: Map<String, Any>
    ): UserSubscription {
        val reason = eventData["reason"] as? String ?: "PAYMENT_FAILED"

        return subscription.copy(
                subscriptionStatus = SubscriptionStatus.EXPIRED,
                expiredAt = Instant.now(),
                expirationReason = reason,
                autoRenewing = false
        )
    }

    private fun handleCancellation(
            subscription: UserSubscription,
            eventData: Map<String, Any>
    ): UserSubscription {
        val reason = eventData["reason"] as? String ?: "USER_CANCELED"

        return subscription.copy(
                subscriptionStatus = SubscriptionStatus.CANCELED,
                canceledAt = Instant.now(),
                cancellationReason = reason,
                autoRenewing = false
        )
    }

    private fun handleRefund(
            subscription: UserSubscription,
            eventData: Map<String, Any>
    ): UserSubscription {
        return subscription.copy(
                subscriptionStatus = SubscriptionStatus.EXPIRED,
                expiredAt = Instant.now(),
                expirationReason = "REFUNDED",
                autoRenewing = false
        )
    }

    private suspend fun logEvent(
            userId: Int,
            platform: Platform,
            eventType: SubscriptionEventType,
            oldStatus: SubscriptionStatus?,
            newStatus: SubscriptionStatus?,
            rawData: String
    ) {
        try {
            val event =
                    SubscriptionEvent(
                            id = null,
                            userId = userId,
                            platform = platform,
                            eventType = eventType,
                            oldStatus = oldStatus,
                            newStatus = newStatus,
                            notificationType = null,
                            transactionId = null,
                            rawNotification = rawData,
                            errorMessage = null
                    )

            subscriptionEventRepo.save(event)
        } catch (e: Exception) {
            logger.warn("Failed to log subscription event", e)
        }
    }
}
