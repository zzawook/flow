package sg.flow.services.BankQueryServices.FinverseQueryService

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.TimeoutCancellationException
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.filter
import kotlinx.coroutines.withTimeout
import org.springframework.stereotype.Component
import sg.flow.models.finverse.FinverseAuthenticationEventTypeParser
import sg.flow.models.finverse.FinverseAuthenticationStatus
import sg.flow.models.finverse.FinverseOverallRetrievalStatus
import kotlin.time.Duration

@Component
class FinverseTimeoutWatcher(
    private val authPublisher: FinverseAuthEventPublisher,
    private val productPublisher: FinverseProductCompleteEventPublisher
) {
    // Use your own scope (e.g. tied to a service, with cancellation in app shutdown)
    private val scope = CoroutineScope(Dispatchers.Default)

    suspend fun watchAuthentication(
        loginIdentityId: String,
        timeout: Duration
    ): FinverseAuthenticationStatus {
        return try {
            val event = withTimeout(timeout) {
                authPublisher.events
                    .filter { it.loginIdentityId == loginIdentityId && it.event_type == "AUTHENTICATED" }
                    .first()
            }
            FinverseAuthenticationEventTypeParser
                .parse(event.event_type)
                ?: FinverseAuthenticationStatus.AUTHENTICATION_FAILED

        } catch (e: TimeoutCancellationException) {
            FinverseAuthenticationStatus.AUTHENTICATION_TIMEOUT
        }
    }

    suspend fun watchDataRetrievalCompletion(
        loginIdentityId: String,
        timeout: Duration
    ) : FinverseOverallRetrievalStatus {
        return try {
            val event = withTimeout(timeout) {
                productPublisher.events
                    .filter { it.loginIdentityId == loginIdentityId }
                    .first()
            }
            event
        } catch (e: TimeoutCancellationException) {
            FinverseOverallRetrievalStatus(
                success = false,
                message = "TIME OUT: $timeout",
                loginIdentityId = loginIdentityId,
            )
        }
    }
}