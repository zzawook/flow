package sg.flow.models.finverse.responses

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.LocalDateTime

@JsonIgnoreProperties(ignoreUnknown = true)
data class FinverseAccountResponse(
        @JsonProperty("accounts") val accounts: List<FinverseAccountData>? = null,
        @JsonProperty("institution") val institution: FinverseInstitutionForAccountResponse,
        @JsonProperty("login_identity") val loginIdentity: FinverseAccountLoginIdentity
) : FinverseProductResponse()

@JsonIgnoreProperties(ignoreUnknown = true)
data class FinverseAccountLoginIdentity(
        @JsonProperty("login_identity_id") val loginIdentityId: String,
        @JsonProperty("status") val status: String,
)

@JsonIgnoreProperties(ignoreUnknown = true)
data class FinverseAccountData(
        @JsonProperty("account_id") val accountId: String,
        @JsonProperty("account_number_masked") val accountNumberMasked: String,
        @JsonProperty("account_name") val accountName: String,
        @JsonProperty("account_type") val accountType: FinverseAccountType,
        @JsonProperty("balance") val balance: FinverseAccountBalance,
)

@JsonIgnoreProperties(ignoreUnknown = true)
data class FinverseAccountType(
        @JsonProperty("subtype") val subtype: String,
        @JsonProperty("type") val type: String
)

@JsonIgnoreProperties(ignoreUnknown = true)
data class FinverseAccountBalance(
        @JsonProperty("currency") val currency: String,
        @JsonProperty("raw") val raw: String,
        @JsonProperty("value") val amount: Double,
)

@JsonIgnoreProperties(ignoreUnknown = true)
data class FinverseInstitutionForAccountResponse(
        @JsonProperty("institution_id") val institutionId: String,
        @JsonProperty("institution_name") val institutionName: String,
        @JsonProperty("countries") val countries: List<String>,
)