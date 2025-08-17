package sg.flow.grpc.mapper

import org.springframework.stereotype.Component
import sg.flow.common.v1.Account as ProtoAccount
import sg.flow.entities.Account as DomainAccount
import sg.flow.models.account.BriefAccount as DomainBriefAccount

@Component
class AccountMapper(
    private val bankMapper: BankMapper,
) {
fun toProto(domain: DomainBriefAccount): ProtoAccount = ProtoAccount.newBuilder()
            .setId(domain.id)
            .setBalance(domain.balance)
            .setAccountName(domain.accountName)
            .setBank(bankMapper.toProto(domain.bank))
            .setAccountNumber(domain.accountNumber)
            .setAccountType(domain.accountType)
            .build()


/** Maps your JPA entity → common.v1.Account */
fun toProto(domain: DomainAccount): ProtoAccount = ProtoAccount.newBuilder()
            .setId(domain.id ?: -1)
            .setBalance(domain.balance)
            .setAccountName(domain.accountName)
            .setBank(bankMapper.toProto(domain.bank))  // relies on the Bank.toProto() you already wrote
            .setAccountNumber(domain.accountNumber)
            .setAccountType(domain.accountType.toString())
            .build()
}
