package sg.flow.models.finverse.responses

import com.fasterxml.jackson.annotation.JsonProperty
import java.time.LocalDateTime

open class FinverseProductResponse {
    @JsonProperty("status") val status: String? = null

    @JsonProperty("message") val message: String? = null

    @JsonProperty("timestamp") val timestamp: LocalDateTime? = null

    @JsonProperty("request_id") val requestId: String? = null
}
