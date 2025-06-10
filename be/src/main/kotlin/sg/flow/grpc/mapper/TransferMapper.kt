package sg.flow.grpc.mapper

import org.springframework.stereotype.Component
import sg.flow.common.v1.CommonBankProto.Bank as ProtoBank
import sg.flow.entities.Bank as DomainBank
import sg.flow.models.transfer.TransferRecepient as DomainTransferRecepient
import sg.flow.models.transfer.TransferResult as DomainTransferResult
import sg.flow.transfer.v1.TransferRecepient as ProtoTransferRecepient
import sg.flow.transfer.v1.TransferResult

@Component
class TransferMapper {
    fun toProto(domain: DomainBank): ProtoBank =
        ProtoBank.newBuilder()
            .setId(domain.id)
            .setName(domain.name)
            .setBankCode(domain.bankCode)
            .build()

    fun toProto(domain: DomainTransferRecepient): ProtoTransferRecepient =
        ProtoTransferRecepient.newBuilder()
            .setName(domain.name)
            .setAccountNumber(domain.accountNumber)
            .setBankCode(domain.bankCode)
            .build()

    fun toDomain(proto: ProtoTransferRecepient): DomainTransferRecepient =
        DomainTransferRecepient(
            name = proto.name,
            accountNumber = proto.accountNumber,
            bankCode = proto.bankCode
        )

    fun toProto(domain: DomainTransferResult): TransferResult =
        TransferResult.newBuilder()
            .setSuccess(domain.success)
            .setMessage(domain.message)
            .build()

}