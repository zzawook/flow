package sg.flow.services.BankQueryServices.FinverseQueryService.fetchers

import org.springframework.stereotype.Service
import org.springframework.web.reactive.function.client.WebClient
import reactor.core.publisher.Mono
import sg.flow.models.finverse.FinverseProduct
import sg.flow.models.finverse.FinverseTransaction
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseDataIngest

@Service
class FinverseTransactionFetcher(finverseIngestor: FinverseDataIngest, webClient: WebClient) :
    FinverseProductFetcher<FinverseTransaction>(finverseIngestor, webClient) {

    override fun fetch(
        product: FinverseProduct,
        loginIdentityId: String
    ): Mono<FinverseTransaction> {
        TODO("Not yet implemented")
    }

}