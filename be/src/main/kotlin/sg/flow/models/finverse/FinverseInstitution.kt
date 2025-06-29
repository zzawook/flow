package sg.flow.models.finverse

import com.fasterxml.jackson.annotation.JsonIgnoreProperties

@JsonIgnoreProperties(ignoreUnknown = true)
data class FinverseInstitution(
    val color: String,
    val countries: List<String>,
    val instituionId: String,
    val institutionName: String,
    val institutionType: String,
    val loginActions: List<String>,
    val loginDetails: Map<String, Boolean>
)