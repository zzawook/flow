package sg.flow.services.BankQueryServices.FinverseQueryService

import kotlinx.coroutines.channels.BufferOverflow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.SharedFlow
import org.springframework.stereotype.Service
import sg.flow.models.finverse.FinverseOverallRetrievalStatus

@Service
class FinverseProductCompleteEventPublisher {
    private val _events = MutableSharedFlow<FinverseOverallRetrievalStatus>(
        replay = 100,
        extraBufferCapacity = 100,
        onBufferOverflow = BufferOverflow.DROP_OLDEST
    )

    val events: SharedFlow<FinverseOverallRetrievalStatus> = _events

    /** Called by your controller whenever a webhook arrives */
    suspend fun publish(event: FinverseOverallRetrievalStatus) {
        _events.emit(event)
    }
}