package sg.flow.services.SubscriptionServices

import com.fasterxml.jackson.databind.ObjectMapper
import java.time.Instant
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import sg.flow.entities.UserSubscription
import sg.flow.entities.utils.Platform
import sg.flow.entities.utils.SubscriptionStatus
import sg.flow.repositories.subscription.SubscriptionRepository
import sg.flow.services.UtilServices.CacheService.CacheService

@Service
class SubscriptionEntitlementServiceImpl(
        private val subscriptionRepo: SubscriptionRepository,
        private val cacheService: CacheService,
        private val objectMapper: ObjectMapper
) : SubscriptionEntitlementService {

    private val logger = LoggerFactory.getLogger(SubscriptionEntitlementServiceImpl::class.java)
    private val CACHE_TTL_SECONDS = 900L // 15 minutes

    override suspend fun checkEntitlement(userId: Int, platform: Platform): EntitlementResult {
        val cacheKey = getCacheKey(userId, platform)

        // Try cache first
        val cached = cacheService.get(cacheKey)
        if (cached != null) {
            logger.debug("Entitlement cache HIT: userId=$userId, platform=$platform")
            return parseEntitlementFromCache(cached)
        }

        logger.debug("Entitlement cache MISS: userId=$userId, platform=$platform")

        // Cache miss - query database
        val subscription =
                subscriptionRepo.findByUserIdAndPlatform(userId, platform)
                        ?: return EntitlementResult.NoSubscription.also {
                            cacheResult(cacheKey, it)
                        }

        val result = computeEntitlement(subscription)

        // Store in cache
        cacheResult(cacheKey, result)

        return result
    }

    override suspend fun hasActiveAccess(userId: Int, platform: Platform): Boolean {
        return checkEntitlement(userId, platform).hasAccess()
    }

    override suspend fun invalidateCache(userId: Int, platform: Platform) {
        val cacheKey = getCacheKey(userId, platform)
        cacheService.delete(cacheKey)
        logger.info("Invalidated entitlement cache: userId=$userId, platform=$platform")
    }

    private fun computeEntitlement(subscription: UserSubscription): EntitlementResult {
        val now = Instant.now()

        return when (subscription.subscriptionStatus) {
            SubscriptionStatus.TRIAL -> {
                if (subscription.trialEndDate != null && subscription.trialEndDate > now) {
                    EntitlementResult.ActiveTrial(subscription.trialEndDate)
                } else {
                    EntitlementResult.Expired
                }
            }
            SubscriptionStatus.ACTIVE -> {
                if (subscription.currentPeriodEnd != null && subscription.currentPeriodEnd > now) {
                    EntitlementResult.ActiveSubscription(subscription.currentPeriodEnd)
                } else {
                    EntitlementResult.Expired
                }
            }
            SubscriptionStatus.CANCELED -> {
                if (subscription.currentPeriodEnd != null && subscription.currentPeriodEnd > now) {
                    EntitlementResult.ActiveButCanceled(subscription.currentPeriodEnd)
                } else {
                    EntitlementResult.Expired
                }
            }
            SubscriptionStatus.EXPIRED -> EntitlementResult.Expired
        }
    }

    private suspend fun cacheResult(cacheKey: String, result: EntitlementResult) {
        try {
            val cacheData =
                    mapOf(
                            "status" to result.getStatus(),
                            "hasAccess" to result.hasAccess(),
                            "expiresAt" to result.getExpirationTime()?.epochSecond
                    )
            val json = objectMapper.writeValueAsString(cacheData)
            cacheService.setex(cacheKey, CACHE_TTL_SECONDS, json)
        } catch (e: Exception) {
            logger.warn("Failed to cache entitlement result", e)
        }
    }

    private fun parseEntitlementFromCache(json: String): EntitlementResult {
        try {
            val data = objectMapper.readValue(json, Map::class.java) as Map<String, Any>
            val status = data["status"] as String
            val expiresAtSeconds = data["expiresAt"] as? Long
            val expiresAt = expiresAtSeconds?.let { Instant.ofEpochSecond(it) }

            return when (status) {
                "TRIAL" -> EntitlementResult.ActiveTrial(expiresAt!!)
                "ACTIVE" -> EntitlementResult.ActiveSubscription(expiresAt!!)
                "CANCELED" -> EntitlementResult.ActiveButCanceled(expiresAt!!)
                "EXPIRED" -> EntitlementResult.Expired
                else -> EntitlementResult.NoSubscription
            }
        } catch (e: Exception) {
            logger.warn("Failed to parse cached entitlement", e)
            return EntitlementResult.NoSubscription
        }
    }

    private fun getCacheKey(userId: Int, platform: Platform): String {
        return "subscription:$userId:${platform.name}"
    }
}
