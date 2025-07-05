package sg.flow.models.finverse.responses

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonProperty

@JsonIgnoreProperties(ignoreUnknown = true)
data class FinverseAccountNumberResponse(
        @JsonProperty("account_number") val accountNumber: FinverseAccountNumberData
) : FinverseProductResponse()

data class FinverseAccountNumberData(
        @JsonProperty("account_id") val accountId: String,
        @JsonProperty("number") val accountNumber: String,
        @JsonProperty("raw") val accountNumberRaw: String,
)
