package sg.flow.services.BankQueryServices.FinverseQueryService

import org.springframework.stereotype.Service
import org.springframework.web.reactive.function.client.WebClient

@Service
class FinverseProductFetchManager(
        private val finverseIngestor: FinverseDataIngest,
        private val webClient: WebClient,
) {}
