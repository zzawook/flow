package sg.flow.grpc.mapper

import org.springframework.stereotype.Component
import sg.flow.common.v1.BriefCard as ProtoBriefCard
import sg.flow.common.v1.CardType as ProtoCardType
import sg.flow.models.card.BriefCard as DomainBriefCard

@Component
class CardMapper {
    fun toProto(domain: DomainBriefCard): ProtoBriefCard =
        ProtoBriefCard.newBuilder()
            .setId(domain.id)
            .setCardNumber(domain.cardNumber)
            .setCardType(ProtoCardType.valueOf(domain.cardType.name))
            .build()
}
