package sg.flow.services.SubscriptionServices

import com.fasterxml.jackson.databind.ObjectMapper
import java.time.Instant
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.http.MediaType
import org.springframework.stereotype.Service
import org.springframework.web.reactive.function.client.WebClient
import org.springframework.web.reactive.function.client.awaitBody
import sg.flow.models.subscription.AppleReceiptResponse
import sg.flow.models.subscription.ReceiptValidationResult

@Service
class AppStoreReceiptValidator(
        @Value("\${subscription.ios.verify-receipt-url.production}")
        private val productionUrl: String,
        @Value("\${subscription.ios.verify-receipt-url.sandbox}") private val sandboxUrl: String,
        @Value("\${subscription.ios.shared-secret:}") private val sharedSecret: String,
        private val webClient: WebClient,
        private val objectMapper: ObjectMapper
) {
    private val logger = LoggerFactory.getLogger(AppStoreReceiptValidator::class.java)

    suspend fun validateReceipt(
            receiptData: String,
            transactionId: String
    ): ReceiptValidationResult {
        logger.info("Validating Apple receipt for transaction: $transactionId")

        // Try production first
        var result = callAppleAPI(productionUrl, receiptData)

        // If status is 21007, it's a sandbox receipt - try sandbox
        if (result.status == 21007) {
            logger.info("Sandbox receipt detected, retrying with sandbox URL")
            result = callAppleAPI(sandboxUrl, receiptData)
        }

        if (result.status != 0) {
            logger.warn("Apple verification failed: status ${result.status}")
            return ReceiptValidationResult(
                    isValid = false,
                    error = "Apple verification failed: status ${result.status}"
            )
        }

        // Parse latest receipt info
        val latestReceipt =
                result.latestReceiptInfo?.firstOrNull()
                        ?: return ReceiptValidationResult(
                                isValid = false,
                                error = "No receipt info"
                        )

        logger.info("Receipt validated successfully: ${latestReceipt.originalTransactionId}")

        return ReceiptValidationResult(
                isValid = true,
                transactionId = latestReceipt.originalTransactionId,
                productId = latestReceipt.productId,
                expiresDate = Instant.ofEpochMilli(latestReceipt.expiresDateMs.toLong()),
                environment = if (result.environment == "Sandbox") "Sandbox" else "Production"
        )
    }

    private suspend fun callAppleAPI(url: String, receiptData: String): AppleReceiptResponse {
        val requestBody =
                mapOf(
                        "receipt-data" to receiptData,
                        "password" to sharedSecret,
                        "exclude-old-transactions" to true
                )

        return webClient
                .post()
                .uri(url)
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(requestBody)
                .retrieve()
                .awaitBody()
    }
}
