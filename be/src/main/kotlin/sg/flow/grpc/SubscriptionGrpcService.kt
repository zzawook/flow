package sg.flow.grpc

import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import sg.flow.entities.utils.Platform
import sg.flow.grpc.mapper.SubscriptionMapper
import sg.flow.grpc.subscription.v1.*
import sg.flow.services.SubscriptionServices.AppStoreReceiptValidator
import sg.flow.services.SubscriptionServices.GooglePlayPurchaseValidator
import sg.flow.services.SubscriptionServices.PurchaseData
import sg.flow.services.SubscriptionServices.SubscriptionEntitlementService
import sg.flow.services.SubscriptionServices.SubscriptionService

@Service
class SubscriptionGrpcService(
        private val subscriptionService: SubscriptionService,
        private val entitlementService: SubscriptionEntitlementService,
        private val appStoreValidator: AppStoreReceiptValidator,
        private val googlePlayValidator: GooglePlayPurchaseValidator
) : SubscriptionServiceGrpcKt.SubscriptionServiceCoroutineImplBase() {

    private val logger = LoggerFactory.getLogger(SubscriptionGrpcService::class.java)

    override suspend fun checkEntitlement(
            request: CheckEntitlementRequest
    ): CheckEntitlementResponse {
        val userId = request.userId
        val platform = Platform.valueOf(request.platform)

        logger.info("Checking entitlement for userId=$userId, platform=$platform")

        val result = entitlementService.checkEntitlement(userId, platform)
        return SubscriptionMapper.toCheckEntitlementResponse(result)
    }

    override suspend fun getSubscriptionStatus(
            request: GetSubscriptionStatusRequest
    ): GetSubscriptionStatusResponse {
        val userId = request.userId
        val platform = Platform.valueOf(request.platform)

        logger.info("Getting subscription status for userId=$userId, platform=$platform")

        val subscription = subscriptionService.getSubscriptionStatus(userId, platform)
        return SubscriptionMapper.toGetSubscriptionStatusResponse(subscription)
    }

    override suspend fun startTrial(request: StartTrialRequest): StartTrialResponse {
        val userId = request.userId
        val platform = Platform.valueOf(request.platform)

        logger.info("Starting trial for userId=$userId, platform=$platform")

        val result = subscriptionService.startTrial(userId, platform)
        return SubscriptionMapper.toStartTrialResponse(result)
    }

    override suspend fun linkPurchase(request: LinkPurchaseRequest): LinkPurchaseResponse {
        try {
            val userId = request.userId
            val platform = Platform.valueOf(request.platform)

            logger.info("Linking purchase for userId=$userId, platform=$platform")

            // Validate purchase with platform and create unified purchase data
            val purchaseData =
                    when (platform) {
                        Platform.IOS -> {
                            val iosResult =
                                    appStoreValidator.validateReceipt(
                                            receiptData = request.purchaseData.iosReceiptData,
                                            transactionId = request.purchaseData.iosTransactionId
                                    )

                            if (!iosResult.isValid) {
                                logger.warn(
                                        "Invalid iOS purchase: userId=$userId, error=${iosResult.error}"
                                )
                                return LinkPurchaseResponse.newBuilder()
                                        .setSuccess(false)
                                        .setMessage("Invalid purchase: ${iosResult.error}")
                                        .setNewStatus("")
                                        .build()
                            }

                            PurchaseData(
                                    platform = platform,
                                    expiresDate = iosResult.expiresDate!!,
                                    originalTransactionId = iosResult.transactionId,
                                    productId = iosResult.productId!!,
                                    purchaseToken = null,
                                    orderId = null
                            )
                        }
                        Platform.ANDROID -> {
                            val androidResult =
                                    googlePlayValidator.validatePurchase(
                                            packageName = "com.flowfinancials.app",
                                            productId = request.purchaseData.androidProductId,
                                            purchaseToken =
                                                    request.purchaseData.androidPurchaseToken
                                    )

                            if (!androidResult.isValid) {
                                logger.warn(
                                        "Invalid Android purchase: userId=$userId, error=${androidResult.error}"
                                )
                                return LinkPurchaseResponse.newBuilder()
                                        .setSuccess(false)
                                        .setMessage("Invalid purchase: ${androidResult.error}")
                                        .setNewStatus("")
                                        .build()
                            }

                            PurchaseData(
                                    platform = platform,
                                    expiresDate = androidResult.expiresDate!!,
                                    originalTransactionId = null,
                                    productId = androidResult.productId!!,
                                    purchaseToken = request.purchaseData.androidPurchaseToken,
                                    orderId = androidResult.orderId
                            )
                        }
                    }

            // Link purchase
            val result = subscriptionService.linkPurchase(userId, platform, purchaseData)
            return SubscriptionMapper.toLinkPurchaseResponse(result)
        } catch (e: Exception) {
            logger.error("Failed to link purchase", e)
            return LinkPurchaseResponse.newBuilder()
                    .setSuccess(false)
                    .setMessage("Failed to link purchase: ${e.message}")
                    .setNewStatus("")
                    .build()
        }
    }
}
