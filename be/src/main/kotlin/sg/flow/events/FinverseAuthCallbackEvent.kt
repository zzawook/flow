package sg.flow.events

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.Instant

@JsonIgnoreProperties(ignoreUnknown = true)
data class FinverseAuthCallbackEvent(
    @JsonProperty("eventId")
    val eventId: String = java.util.UUID.randomUUID().toString(),
    
    @JsonProperty("timestamp")
    val timestamp: Instant = Instant.now(),
    
    @JsonProperty("userId")
    val userId: Int,
    
    @JsonProperty("code")
    val code: String,
    
    @JsonProperty("state")
    val state: String,
    
    @JsonProperty("institutionId")
    val institutionId: String = "testbank" // Default from current implementation
)
