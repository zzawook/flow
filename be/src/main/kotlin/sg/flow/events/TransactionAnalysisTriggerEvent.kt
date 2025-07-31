package sg.flow.events

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.Instant

@JsonIgnoreProperties(ignoreUnknown = true)
data class TransactionAnalysisTriggerEvent(
        @JsonProperty("eventId") val eventId: String = java.util.UUID.randomUUID().toString(),
        @JsonProperty("timestamp") val timestamp: Instant = Instant.now(),
        @JsonProperty("userId") val userId: Int,
        @JsonProperty("institutionId") val institutionId: String,
        @JsonProperty("loginIdentityId") val loginIdentityId: String,
        @JsonProperty("totalTransactionsRetrieved") val totalTransactionsRetrieved: Int = 0
)
