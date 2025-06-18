package sg.flow.models.finverse

data class FinverseOverallRetrievalStatus(
    val loginIdentityId: String,
    val success: Boolean,
    val message: String
)