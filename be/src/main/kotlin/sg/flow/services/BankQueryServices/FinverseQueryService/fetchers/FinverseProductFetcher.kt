package sg.flow.services.BankQueryServices.FinverseQueryService.fetchers

import org.springframework.stereotype.Service
import org.springframework.web.reactive.function.client.WebClient
import reactor.core.publisher.Mono
import sg.flow.models.finverse.FinverseProduct
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseDataIngest

@Service
abstract class FinverseProductFetcher<A>(
    private val finverseIngestor: FinverseDataIngest,
    private val webClient: WebClient
) {
    abstract fun fetch(product: FinverseProduct, loginIdentityId: String): Mono<A>
}