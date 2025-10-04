package sg.flow.grpc

import aws.smithy.kotlin.runtime.util.length
import io.grpc.Status
import org.springframework.grpc.server.service.GrpcService
import sg.flow.auth.GrpcSecurityContext
import sg.flow.card.v1.CardServiceGrpcKt
import sg.flow.card.v1.GetCardsRequest
import sg.flow.card.v1.GetCardsResponse
import sg.flow.grpc.mapper.CardMapper
import sg.flow.services.CardServices.CardService

@GrpcService
class CardGrpcService(
    private val cardService: CardService,
    private val cardMapper: CardMapper,
) : CardServiceGrpcKt.CardServiceCoroutineImplBase() {

    private fun currentUserId(): Int {
        val user = GrpcSecurityContext.USER_DETAILS.get()
            ?: throw Status.UNAUTHENTICATED.withDescription("No user in context").asRuntimeException()
        return user.userId
    }

    override suspend fun getCards(request: GetCardsRequest): GetCardsResponse {
        val userId = currentUserId()
        val cardList = cardService.getCards(userId)
        val protoCardList = cardMapper.toProto(cardList)
        return GetCardsResponse.newBuilder().addAllCards(protoCardList).build()
    }
}