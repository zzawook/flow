package sg.flow.grpc.mapper

import org.springframework.stereotype.Component
import sg.flow.common.v1.CommonBankProto.Bank as ProtoBank
import sg.flow.entities.Bank as DomainBank

@Component
class BankMapper {
    fun toProto(domain: DomainBank): ProtoBank =
        ProtoBank.newBuilder()
            .setId(domain.id ?: -1)
            .setName(domain.name)
            .setBankCode(domain.bankCode)
            .build()
}
