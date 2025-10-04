package sg.flow.grpc.mapper

import org.springframework.stereotype.Component
import sg.flow.entities.Card
import sg.flow.common.v1.BriefCard as ProtoBriefCard
import sg.flow.common.v1.CardType as ProtoCardType
import sg.flow.common.v1.Card as ProtoCard
import sg.flow.common.v1.CommonBankProto.Bank as ProtoBank
import sg.flow.models.card.BriefCard as DomainBriefCard

@Component
class CardMapper {
    fun toProto(domain: DomainBriefCard): ProtoBriefCard =
        ProtoBriefCard.newBuilder()
            .setId(domain.id)
            .setCardNumber(domain.cardNumber)
            .setCardType(ProtoCardType.valueOf(domain.cardType.name))
            .build()

    fun toProto(card: Card): ProtoCard =
        ProtoCard.newBuilder()
            .setId(card.id ?: -1L)
            .setCardNumber(card.cardNumber)
            .setCardType(ProtoCardType.valueOf(card.cardType.name))
            .setBalance(card.balance)
            .setBank(ProtoBank.newBuilder()
                .setId(card.issuingBank?.id ?: -1)
                .setName(card.issuingBank?.name)
                .setBankCode(card.issuingBank?.bankCode)
                .build())
            .setCardName(card.cardName)
            .build()

    fun toProto(cardList: List<Card>): List<ProtoCard> =
        cardList.map { card -> toProto(card) }
}
