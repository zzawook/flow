package sg.flow.grpc

import com.google.protobuf.Empty
import com.google.protobuf.Timestamp
import io.grpc.Status
import org.springframework.grpc.server.service.GrpcService
import org.springframework.security.core.context.SecurityContextHolder
import sg.flow.grpc.mapper.TransferMapper
import sg.flow.common.v1.CommonBankProto.Bank as ProtoBank
import sg.flow.entities.Bank as DomainBank
import sg.flow.transfer.v1.GetRelevantRecepientByAccountNumberRequest
import sg.flow.transfer.v1.GetRelevantRecepientByAccountNumberResponse
import sg.flow.transfer.v1.GetRelevantRecepientByContactRequest
import sg.flow.transfer.v1.GetRelevantRecepientResponse
import sg.flow.transfer.v1.TransferRecepient as ProtoTransferRecepient
import sg.flow.transfer.v1.TransferRequest
import sg.flow.transfer.v1.TransferResult
import sg.flow.transfer.v1.TransferServiceGrpcKt.TransferServiceCoroutineImplBase
import sg.flow.models.auth.FlowUserDetails
import sg.flow.models.transfer.TransferRecepient as DomainTransferRecepient
import sg.flow.models.transfer.TransferRequestBody
import sg.flow.models.transfer.TransferResult as DomainTransferResult
import sg.flow.services.TransferServices.TransferService as DomainTransferService
import java.time.Instant
import java.time.LocalDateTime
import java.time.ZoneOffset

@GrpcService
class TransferGrpcService(
    private val transferService: DomainTransferService,
    private val transferMapper: TransferMapper
) : TransferServiceCoroutineImplBase() {

    override suspend fun getRelevantRecepientByAccountNumber(
        request: GetRelevantRecepientByAccountNumberRequest
    ): GetRelevantRecepientByAccountNumberResponse {
        val banks: List<DomainBank> = transferService.getRelevantRecepientByAccountNumber(request.keyword)
        val resp = GetRelevantRecepientByAccountNumberResponse.newBuilder()
        banks.forEach { resp.addBanks(transferMapper.toProto(it)) }
        return resp.build()
    }

    override suspend fun getRelevantRecepientByContact(
        request: GetRelevantRecepientByContactRequest
    ): ProtoTransferRecepient {
        val dr: DomainTransferRecepient = transferService.getRelevantRecepientByContact(request.keyword)
        return transferMapper.toProto(dr)
    }

    override suspend fun getRelevantRecepient(
        request: Empty
    ): GetRelevantRecepientResponse {
        val list: List<DomainTransferRecepient> = transferService.getRelevantRecepient()
        val resp = GetRelevantRecepientResponse.newBuilder()
        list.forEach { resp.addRecipients(transferMapper.toProto(it)) }
        return resp.build()
    }

    override suspend fun sendTransaction(
        request: TransferRequest
    ): TransferResult {
        val domainReq = TransferRequestBody(
            senderAccountNumber = request.senderAccountNumber,
            recepient = transferMapper.toDomain(request.recepient),
            amount = request.amount,
            note = request.note.takeIf { it.isNotEmpty() },
            scheduledAt = if (request.hasScheduledAt()) {
                val ts = request.scheduledAt
                LocalDateTime.ofInstant(Instant.ofEpochSecond(ts.seconds, ts.nanos.toLong()), ZoneOffset.UTC)
            } else null
        )
        val result: DomainTransferResult = transferService.sendTransaction(domainReq)
        return transferMapper.toProto(result)
    }
}
