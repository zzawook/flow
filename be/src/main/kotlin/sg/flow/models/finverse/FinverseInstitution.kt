package sg.flow.models.finverse

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonProperty

@JsonIgnoreProperties(ignoreUnknown = true)
data class FinverseInstitution(
        @JsonProperty("institution_id") val institutionId: String,
        @JsonProperty("institution_name") val institutionName: String,
        @JsonProperty("institution_type") val institutionType: String,
        @JsonProperty("countries") val countries: List<String>,
        @JsonProperty("color") val color: String? = null,
        @JsonProperty("logo_url") val logoUrl: String? = null,
        @JsonProperty("website_url") val websiteUrl: String? = null,
//        @JsonProperty("login_actions") val loginActions: List<String>? = null,
//        @JsonProperty("login_details") val loginDetails: Map<String, Any>? = null,
        @JsonProperty("products_supported") val productsSupported: List<String>? = null,
        @JsonProperty("is_active") val isActive: Boolean? = null,
        @JsonProperty("is_test") val isTest: Boolean? = null,
        @JsonProperty("status") val status: String? = null,
        @JsonProperty("bank_code") val bankCode: String? = null,
        @JsonProperty("swift_code") val swiftCode: String? = null,
        @JsonProperty("routing_number") val routingNumber: String? = null,
        @JsonProperty("institution_category") val institutionCategory: String? = null,
        @JsonProperty("description") val description: String? = null,
        @JsonProperty("headquarters_location") val headquartersLocation: String? = null,
        @JsonProperty("customer_support_phone") val customerSupportPhone: String? = null,
        @JsonProperty("customer_support_email") val customerSupportEmail: String? = null,
        @JsonProperty("last_updated") val lastUpdated: String? = null
)
