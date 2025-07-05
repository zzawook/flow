package sg.flow.models.finverse.responses

import com.fasterxml.jackson.annotation.JsonProperty
import java.time.LocalDate

data class FinverseIdentityResponse(
        @JsonProperty("identity") val identity: FinverseIdentityData? = null
) : FinverseProductResponse()

data class FinverseIdentityData(
        @JsonProperty("names") val names: List<String>? = null,
        @JsonProperty("emails") val emails: List<String>? = null,
        @JsonProperty("phone_numbers") val phoneNumbers: List<String>? = null,
        @JsonProperty("addresses") val addresses: List<FinverseAddressData>? = null,
        @JsonProperty("date_of_birth") val dateOfBirth: LocalDate? = null,
        @JsonProperty("national_id") val nationalId: String? = null,
        @JsonProperty("tax_id") val taxId: String? = null,
        @JsonProperty("citizenship") val citizenship: String? = null,
        @JsonProperty("employment_status") val employmentStatus: String? = null,
        @JsonProperty("occupation") val occupation: String? = null
)

data class FinverseAddressData(
        @JsonProperty("street") val street: String? = null,
        @JsonProperty("city") val city: String? = null,
        @JsonProperty("state") val state: String? = null,
        @JsonProperty("postal_code") val postalCode: String? = null,
        @JsonProperty("country") val country: String? = null,
        @JsonProperty("type") val type: String? = null
)
