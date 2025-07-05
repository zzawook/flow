package sg.flow.models.finverse.responses

import com.fasterxml.jackson.annotation.JsonProperty

data class FinverseAccountNumberResponse(
        @JsonProperty("account_numbers") val accountNumbers: List<FinverseAccountNumberData>? = null
) : FinverseProductResponse()

data class FinverseAccountNumberData(
        @JsonProperty("account_id") val accountId: String,
        @JsonProperty("account_number") val accountNumber: String,
        @JsonProperty("routing_number") val routingNumber: String? = null,
        @JsonProperty("sort_code") val sortCode: String? = null,
        @JsonProperty("iban") val iban: String? = null,
        @JsonProperty("swift_code") val swiftCode: String? = null,
        @JsonProperty("account_type") val accountType: String,
        @JsonProperty("account_name") val accountName: String,
        @JsonProperty("institution_id") val institutionId: String,
        @JsonProperty("institution_name") val institutionName: String,
        @JsonProperty("bank_code") val bankCode: String? = null,
        @JsonProperty("is_primary") val isPrimary: Boolean? = null,
        @JsonProperty("status") val status: String? = null
)
