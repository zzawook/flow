package sg.flow.grpc

import java.time.LocalDate
import io.grpc.Status
import org.springframework.grpc.server.service.GrpcService
import sg.flow.auth.GrpcSecurityContext
import sg.flow.grpc.exception.InvalidTimestampRangeException
import sg.flow.grpc.exception.InvalidTransactionIdException
import sg.flow.grpc.exception.InvalidYearMonthDayException
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
import sg.flow.models.transaction.TransactionHistoryList       as DomainHistoryList
import sg.flow.services.TransactionHistoryServices.TransactionHistoryService
import sg.flow.transaction.v1.GetProcessedTransactionRequest
import sg.flow.transaction.v1.GetRecurringTransactionRequest
import sg.flow.transaction.v1.GetRecurringTransactionResponse
import sg.flow.transaction.v1.GetTransactionForAccountRequest
import sg.flow.transaction.v1.SetTransactionCategoryRequest
import sg.flow.transaction.v1.SetTransactionCategoryResponse
import sg.flow.transaction.v1.SetTransactionInclusionRequest
import sg.flow.transaction.v1.SetTransactionInclusionResponse
import sg.flow.validation.ValidationException
import sg.flow.validation.Validator

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
                try {
                        Validator.validateYear(request.year)
                        Validator.validateMonth(request.month)
                } catch (e : ValidationException) {
                        throw InvalidYearMonthDayException(
                                e.message ?: "Could not validate year/month value provided"
                        )
                }

                val userId = currentUserId()
                val domain = transactionService.getMonthlyTransaction(
                        userId, request.year, request.month
                )
                return txHistoryMapper.toProto(domain)
        }

        override suspend fun getDailyTransaction(
                request: GetDailyTransactionRequest
        ): ProtoTransactionHistoryList {
                try {
                        Validator.validateYear(request.year)
                        Validator.validateMonth(request.month)
                        Validator.validateDayOfMonth(request.day)
                } catch (e : ValidationException) {
                        throw InvalidYearMonthDayException(e.message ?: "Could not validate year/month/day value provided")
                }

                val userId = currentUserId()
                val date = LocalDate.of(request.year, request.month, request.day)
                val domain = transactionService.getDailyTransaction(userId, date)
                return txHistoryMapper.toProto(domain)
        }

        override suspend fun getTransactionDetails(
                request: GetTransactionDetailsRequest
        ): ProtoTransactionHistoryDetail {
                try {
                        Validator.validateStringValidLong(request.transactionId)
                } catch (e : ValidationException) {
                        throw InvalidTransactionIdException(e.message ?: "Could not validate transaction ID")
                }

                val userId = currentUserId()
                val detail = transactionService.getTransactionDetails(
                        userId, request.transactionId
                )
                return txHistoryMapper.toProto(detail)
        }

        override suspend fun getTransactionWithinRange(
                request: GetTransactionWithinRangeRequest
        ): ProtoTransactionHistoryList {
                try {
                        Validator.validateTimestamp(request.startTimestamp)
                        Validator.validateTimestamp(request.endTimestamp)
                        Validator.validateStartTimestampIsNotAfterEndTimestamp(request.startTimestamp, request.endTimestamp)
                } catch (e : ValidationException) {
                        throw InvalidTimestampRangeException(e.message ?: "Could not validate timestamp range by provided start and and timestamp")
                }

                val userId = currentUserId()
                // convert incoming Timestamps → LocalDate
                val startDate = datetimeMapper.toLocalDate(request.startTimestamp)
                val endDate   = datetimeMapper.toLocalDate(request.endTimestamp)
                val domain = transactionService.getTransactionWithinRange(
                        userId, startDate, endDate
                )
                return txHistoryMapper.toProto(domain)
        }

        override suspend fun getProcessedTransaction(request: GetProcessedTransactionRequest): ProtoTransactionHistoryList {
                val userId = currentUserId()
                val domain = transactionService.getProcessedTransactionsForTransactionIds(userId, request.transactionIdsList.toList())
                return txHistoryMapper.toProto(domain)
        }

        override suspend fun getRecurringTransaction(request: GetRecurringTransactionRequest): GetRecurringTransactionResponse {
                val userId = currentUserId()
                val domain = transactionService.getRecurringTransactionAnalysisResult(userId)
                val toReturn = txHistoryMapper.toProto(domain)
                return toReturn
        }

        override suspend fun setTransactionCategory(request: SetTransactionCategoryRequest): SetTransactionCategoryResponse {
                val userId = currentUserId()
                val success = transactionService.setTransactionCategory(userId, request.transactionId, request.category)
                return SetTransactionCategoryResponse.newBuilder().setSuccess(success).build()
        }

        override suspend fun setTransactionInclusion(request: SetTransactionInclusionRequest): SetTransactionInclusionResponse {
                val userId = currentUserId()
                val success = transactionService.setTransactionInclusion(userId, request.transactionId, request.includeInSpendingOrIncome)
                return SetTransactionInclusionResponse.newBuilder().setSuccess(success).build()
        }

        override suspend fun getTransactionForAccount(request: GetTransactionForAccountRequest): ProtoTransactionHistoryList {
                val userId = currentUserId()
                val domainTransactions = transactionService.getTransactionsForAccount(userId, request.accountNumber, request.bankId, request.oldestTransactionId, request.limit.toInt())
                return txHistoryMapper.toProto(domainTransactions)
        }
}