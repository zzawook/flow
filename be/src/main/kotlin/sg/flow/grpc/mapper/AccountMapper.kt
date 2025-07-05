package sg.flow.grpc.mapper

import org.springframework.stereotype.Component
import sg.flow.common.v1.BriefAccount as ProtoBriefAccount

import sg.flow.models.account.BriefAccount as DomainBriefAccount
import sg.flow.entities.Account as DomainAccount

@Component
class AccountMapper(
    private val bankMapper: BankMapper,
) {
    fun toProto(domain: DomainBriefAccount): ProtoBriefAccount =
        ProtoBriefAccount.newBuilder()
            .setId(domain.id)
            .setBalance(domain.balance)
            .setAccountName(domain.accountName)
            .setBank(bankMapper.toProto(domain.bank))
            .build()


    /** Maps your JPA entity → common.v1.BriefAccount */
    fun toProto(domain: DomainAccount): ProtoBriefAccount =
        ProtoBriefAccount.newBuilder()
            .setId(domain.id ?: -1)
            .setBalance(domain.balance)
            .setAccountName(domain.accountName)
            .setBank(bankMapper.toProto(domain.bank))  // relies on the Bank.toProto() you already wrote
            .build()
}
