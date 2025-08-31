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
        @JsonProperty("status") val status: String? = null,
        @JsonProperty("updated_at") val lastUpdated: String? = null,
        @JsonProperty("user_type") val userType: String? = null,
        @JsonProperty("parent_institution_name") val parentInstitutionName: String? = null,
)
