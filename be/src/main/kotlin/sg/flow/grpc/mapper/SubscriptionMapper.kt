package sg.flow.grpc.mapper

import com.google.protobuf.Timestamp
import java.time.Instant
import sg.flow.entities.UserSubscription
import sg.flow.entities.utils.Platform
import sg.flow.grpc.subscription.v1.*
import sg.flow.services.SubscriptionServices.EntitlementResult
import sg.flow.services.SubscriptionServices.LinkPurchaseResult
import sg.flow.services.SubscriptionServices.PurchaseData
import sg.flow.services.SubscriptionServices.TrialStartResult

object SubscriptionMapper {

    fun toCheckEntitlementResponse(result: EntitlementResult): CheckEntitlementResponse {
        return CheckEntitlementResponse.newBuilder()
                .setHasAccess(result.hasAccess())
                .setStatus(result.getStatus())
                .apply { result.getExpirationTime()?.let { setAccessExpiresAt(it.toTimestamp()) } }
                .setMessage("")
                .build()
    }

    fun toGetSubscriptionStatusResponse(
            subscription: UserSubscription?
    ): GetSubscriptionStatusResponse {
        return if (subscription != null) {
            GetSubscriptionStatusResponse.newBuilder()
                    .setStatus(subscription.subscriptionStatus.name)
                    .setPlatform(subscription.platform.name)
                    .apply {
                        subscription.trialStartDate?.let { setTrialStartDate(it.toTimestamp()) }
                        subscription.trialEndDate?.let { setTrialEndDate(it.toTimestamp()) }
                        subscription.currentPeriodStart?.let {
                            setCurrentPeriodStart(it.toTimestamp())
                        }
                        subscription.currentPeriodEnd?.let { setCurrentPeriodEnd(it.toTimestamp()) }
                    }
                    .setAutoRenewing(subscription.autoRenewing)
                    .setProductId(
                            when (subscription.platform) {
                                Platform.IOS -> subscription.iosProductId ?: ""
                                Platform.ANDROID -> subscription.androidProductId ?: ""
                            }
                    )
                    .build()
        } else {
            GetSubscriptionStatusResponse.newBuilder()
                    .setStatus("NO_SUBSCRIPTION")
                    .setPlatform("")
                    .setAutoRenewing(false)
                    .setProductId("")
                    .build()
        }
    }

    fun toStartTrialResponse(result: TrialStartResult): StartTrialResponse {
        return when (result) {
            is TrialStartResult.Success -> {
                StartTrialResponse.newBuilder()
                        .setSuccess(true)
                        .setMessage("Trial started successfully")
                        .setTrialEndDate(result.trialEndDate.toTimestamp())
                        .build()
            }
            is TrialStartResult.AlreadyUsed -> {
                StartTrialResponse.newBuilder()
                        .setSuccess(false)
                        .setMessage(result.message)
                        .setAlreadyUsedPlatform(result.platform.name)
                        .setAlreadyUsedDate(result.firstUsedDate.toTimestamp())
                        .build()
            }
            is TrialStartResult.AlreadySubscribed -> {
                StartTrialResponse.newBuilder().setSuccess(false).setMessage(result.message).build()
            }
        }
    }

    fun toPurchaseData(
            proto: sg.flow.grpc.subscription.v1.PurchaseData,
            platform: Platform
    ): PurchaseData {
        return PurchaseData(
                platform = platform,
                expiresDate = Instant.now(), // Will be set by validator
                originalTransactionId =
                        if (proto.iosTransactionId.isNotEmpty()) proto.iosTransactionId else null,
                productId =
                        when (platform) {
                            Platform.IOS -> proto.iosReceiptData
                            Platform.ANDROID -> proto.androidProductId
                        },
                purchaseToken =
                        if (proto.androidPurchaseToken.isNotEmpty()) proto.androidPurchaseToken
                        else null,
                orderId = if (proto.androidOrderId.isNotEmpty()) proto.androidOrderId else null
        )
    }

    fun toLinkPurchaseResponse(result: LinkPurchaseResult): LinkPurchaseResponse {
        return when (result) {
            is LinkPurchaseResult.Success -> {
                LinkPurchaseResponse.newBuilder()
                        .setSuccess(true)
                        .setMessage("Purchase linked successfully")
                        .setNewStatus(result.subscription.subscriptionStatus.name)
                        .apply {
                            result.subscription.currentPeriodEnd?.let {
                                setPeriodEnd(it.toTimestamp())
                            }
                        }
                        .build()
            }
            is LinkPurchaseResult.Failure -> {
                LinkPurchaseResponse.newBuilder()
                        .setSuccess(false)
                        .setMessage(result.message)
                        .setNewStatus("")
                        .build()
            }
        }
    }

    private fun Instant.toTimestamp(): Timestamp {
        return Timestamp.newBuilder().setSeconds(this.epochSecond).setNanos(this.nano).build()
    }
}
