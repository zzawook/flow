package sg.flow.grpc

import java.time.LocalDate
import io.grpc.Status
import org.springframework.grpc.server.service.GrpcService
import org.springframework.security.core.context.SecurityContextHolder
import sg.flow.auth.GrpcSecurityContext
import sg.flow.grpc.mapper.DateTimeMapper
import sg.flow.grpc.mapper.TransactionHistoryMapper
import sg.flow.common.v1.TransactionHistoryDetail as ProtoTransactionHistoryDetail
import sg.flow.common.v1.TransactionHistoryList   as ProtoTransactionHistoryList
import sg.flow.transaction.v1.TransactionHistoryServiceGrpcKt
import sg.flow.transaction.v1.GetLast30DaysHistoryListRequest
import sg.flow.transaction.v1.GetMonthlyTransactionRequest
import sg.flow.transaction.v1.GetDailyTransactionRequest
import sg.flow.transaction.v1.GetTransactionDetailsRequest
import sg.flow.transaction.v1.GetTransactionWithinRangeRequest
import sg.flow.models.auth.FlowUserDetails
import sg.flow.models.transaction.TransactionHistoryList       as DomainHistoryList
import sg.flow.services.TransactionHistoryServices.TransactionHistoryService

@GrpcService
class TransactionHistoryGrpcService(
        private val transactionService: TransactionHistoryService,
        private val txHistoryMapper: TransactionHistoryMapper,
        private val datetimeMapper: DateTimeMapper,
) : TransactionHistoryServiceGrpcKt.TransactionHistoryServiceCoroutineImplBase() {

        private fun currentUserId(): Int {
                val user = GrpcSecurityContext.USER_DETAILS.get()
                        ?: throw Status.UNAUTHENTICATED.withDescription("No user in context").asRuntimeException()
                return user.userId
        }


        override suspend fun getLast30DaysHistoryList(
                request: GetLast30DaysHistoryListRequest
        ): ProtoTransactionHistoryList {
                val userId = currentUserId()
                val domain: DomainHistoryList = transactionService.getLast30DaysHistoryList(userId)
                return txHistoryMapper.toProto(domain)
        }

        override suspend fun getMonthlyTransaction(
                request: GetMonthlyTransactionRequest
        ): ProtoTransactionHistoryList {
                val userId = currentUserId()
                val domain = transactionService.getMonthlyTransaction(
                        userId, request.year, request.month
                )
                return txHistoryMapper.toProto(domain)
        }

        override suspend fun getDailyTransaction(
                request: GetDailyTransactionRequest
        ): ProtoTransactionHistoryList {
                val userId = currentUserId()
                val date = LocalDate.of(request.year, request.month, request.day)
                val domain = transactionService.getDailyTransaction(userId, date)
                return txHistoryMapper.toProto(domain)
        }

        override suspend fun getTransactionDetails(
                request: GetTransactionDetailsRequest
        ): ProtoTransactionHistoryDetail {
                val userId = currentUserId()
                val detail = transactionService.getTransactionDetails(
                        userId, request.transactionId
                )
                return txHistoryMapper.toProto(detail)
        }

        override suspend fun getTransactionWithinRange(
                request: GetTransactionWithinRangeRequest
        ): ProtoTransactionHistoryList {
                val userId = currentUserId()
                // convert incoming Timestamps → LocalDate
                val startDate = datetimeMapper.toLocalDate(request.startTimestamp)
                val endDate   = datetimeMapper.toLocalDate(request.endTimestamp)
                val domain = transactionService.getTransactionWithinRange(
                        userId, startDate, endDate
                )
                return txHistoryMapper.toProto(domain)
        }
}