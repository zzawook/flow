package sg.flow.grpc.mapper

import com.google.protobuf.DoubleValue
import com.google.protobuf.Timestamp
import org.springframework.stereotype.Component
import sg.flow.common.v1.RecurringTransactionDetail
import sg.flow.entities.RecurringSpendingMonthly
import sg.flow.transaction.v1.GetRecurringTransactionResponse
import java.time.LocalDate
import sg.flow.common.v1.TransactionHistoryList as ProtoTransactionHistoryList
import sg.flow.models.transaction.TransactionHistoryList as DomainHistoryList
import sg.flow.common.v1.TransactionHistoryDetail as ProtoTxDetail
import sg.flow.models.transaction.TransactionHistoryDetail as DomainTxDetail
import java.time.ZoneOffset
import java.time.LocalDateTime
import java.time.LocalTime
import sg.flow.account.v1.AccountWithTransactionHistory as ProtoAccountWithTransactionHistory
import sg.flow.models.account.AccountWithTransactionHistory as DomainAccountWithTransactionHistory

@Component
class TransactionHistoryMapper(
    private val accountMapper: AccountMapper,
    private val cardMapper: CardMapper,
    private val bankMapper: BankMapper
) {
    fun toProto(domain: DomainTxDetail): ProtoTxDetail {
        val b = ProtoTxDetail.newBuilder()
            .setId(domain.id)
            .setTransactionReference(domain.transactionReference ?: "")
        domain.account?.let { b.setAccount(accountMapper.toProto(it)) }
        domain.card   ?.let { b.setCard(cardMapper.toProto(it)) }

        if (domain.transactionDate != null) {
            val dt : LocalDateTime
            if (domain.transactionTime != null) {
                dt = LocalDateTime.of(domain.transactionDate, domain.transactionTime)
            } else {
                dt = LocalDateTime.of(domain.transactionDate, LocalTime.now())
            }

            b.setTransactionTimestamp(
                Timestamp.newBuilder()
                    .setSeconds(dt.toEpochSecond(ZoneOffset.UTC))
                    .setNanos(dt.nano)
                    .build()
            )
        }

        if (domain.revisedTransactionDate != null) {
            val dt = LocalDateTime.of(domain.revisedTransactionDate, LocalTime.now())
            b.setTransactionTimestamp(
                Timestamp.newBuilder()
                    .setSeconds(dt.toEpochSecond(ZoneOffset.UTC))
                    .setNanos(dt.nano)
                    .build()
            )
        }

        b.setAmount(domain.amount)
            .setDescription(domain.description)
        domain.transactionType     ?.let(b::setTransactionType)
        domain.transactionStatus   ?.let(b::setTransactionStatus)
        domain.friendlyDescription ?.let(b::setFriendlyDescription)
        domain.transactionCategory ?.let(b::setTransactionCategory)
        domain.brandName           ?.let(b::setBrandName)
        return b.build()
    }

    fun toProto(domain: DomainHistoryList): ProtoTransactionHistoryList {
        val builder = ProtoTransactionHistoryList.newBuilder()

        // Inline LocalDate → midnight UTC Timestamp
        val startDt = domain.startDate.atStartOfDay(ZoneOffset.UTC)
        val startTs = Timestamp.newBuilder()
            .setSeconds(startDt.toEpochSecond())
            .setNanos(0)
            .build()

        val endDt = domain.endDate.atStartOfDay(ZoneOffset.UTC)
        val endTs = Timestamp.newBuilder()
            .setSeconds(endDt.toEpochSecond())
            .setNanos(0)
            .build()

        builder
            .setStartTimestamp(startTs)
            .setEndTimestamp(endTs)

        // Add each transaction
        domain.transactions.forEach { detail ->
            builder.addTransactions(this.toProto(detail))
        }

        return builder.build()
    }

    fun toProto(domain: DomainAccountWithTransactionHistory): ProtoAccountWithTransactionHistory {
        val b = ProtoAccountWithTransactionHistory.newBuilder()
            .setId(domain.id)
            .setAccountNumber(domain.accountNumber)
            .setBalance(domain.balance)
            .setAccountName(domain.accountName)
            .setAccountType(sg.flow.account.v1.AccountType.valueOf(domain.accountType.name))
            .also {
                domain.interestRatePerAnnum?.let { rate ->
                    it.setInterestRatePerAnnum(DoubleValue.of(rate))
                }
            }
            .setBank(bankMapper.toProto(domain.bank))

        domain.recentTransactionHistoryDetails
            .map(this::toProto)
            .forEach { b.addRecentTransactionHistoryDetails(it) }

        return b.build()
    }

    fun toProto(domain: List<RecurringSpendingMonthly>): GetRecurringTransactionResponse {
        val proto = GetRecurringTransactionResponse.newBuilder()
        var dIndex = 0
        for (d in domain) {
            var nextTxDate: Timestamp? = null
            if (d.nextTransactionDate != null) {
                nextTxDate = Timestamp.newBuilder()
                    .setSeconds(d.nextTransactionDate.atStartOfDay(ZoneOffset.UTC).toEpochSecond())
                    .setNanos(0)
                    .build()
            }
            var lastTxDate: Timestamp? = null
            if (d.lastTransactionDate != null) {
                lastTxDate = Timestamp.newBuilder()
                    .setSeconds(d.lastTransactionDate.atStartOfDay(ZoneOffset.UTC).toEpochSecond())
                    .setNanos(0)
                    .build()
            }
            val b = RecurringTransactionDetail.newBuilder()
                .setId(d.id ?: -1)
                .setDisplayName(d.displayName)
                .setCategory(d.category)
                .setExpectedAmount(d.expectedAmount)
                .setNextTransactionDate(nextTxDate)
                .setLastTransactionDate(lastTxDate)
                .setIntervalDays(d.intervalDays?.toLong() ?: -1)
                .setOccurrenceCount(d.occurrenceCount.toLong())
                .setMonth(d.month.toLong())
                .setYear(d.year.toLong())

            if (d.transactionIds != null) {
                var index = 0
                for (tx in d.transactionIds) {
                    b.setTransactionIds(index, tx)
                    index++
                }
            }

            proto.setRecurringTransactions(dIndex, b.build())
            dIndex++
        }
        return proto.build()
    }
}
