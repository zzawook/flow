package sg.flow.grpc.mapper

import com.google.protobuf.Timestamp
import java.time.ZoneOffset
import org.springframework.stereotype.Component
import sg.flow.account.v1.DailyAsset
import sg.flow.account.v1.GetDailyAssetsResponse
import sg.flow.account.v1.GetLast6MonthsEndOfMonthAssetsResponse
import sg.flow.account.v1.GetLast7DaysAssetsResponse
import sg.flow.common.v1.Account as ProtoAccount
import sg.flow.entities.Account as DomainAccount
import sg.flow.entities.DailyUserAsset
import sg.flow.models.account.BriefAccount as DomainBriefAccount

@Component
class AccountMapper(
        private val bankMapper: BankMapper,
) {
    fun toProto(domain: DomainBriefAccount): ProtoAccount =
            ProtoAccount.newBuilder()
                    .setId(domain.id)
                    .setBalance(domain.balance)
                    .setAccountName(domain.accountName)
                    .setBank(bankMapper.toProto(domain.bank))
                    .setAccountNumber(domain.accountNumber)
                    .setAccountType(domain.accountType)
                    .build()

    /** Maps your JPA entity → common.v1.Account */
    fun toProto(domain: DomainAccount): ProtoAccount =
            ProtoAccount.newBuilder()
                    .setId(domain.id ?: -1)
                    .setBalance(domain.balance)
                    .setAccountName(domain.accountName)
                    .setBank(
                            bankMapper.toProto(domain.bank)
                    ) // relies on the Bank.toProto() you already wrote
                    .setAccountNumber(domain.accountNumber)
                    .setAccountType(domain.accountType.toString())
                    .build()

    /** Maps DailyUserAsset entity → DailyAsset proto */
    fun toProtoDailyAsset(domain: DailyUserAsset): DailyAsset {
        val assetDateTimestamp =
                Timestamp.newBuilder()
                        .setSeconds(domain.assetDate.atStartOfDay(ZoneOffset.UTC).toEpochSecond())
                        .setNanos(0)
                        .build()

        val calculatedAtTimestamp =
                Timestamp.newBuilder()
                        .setSeconds(domain.calculatedAt.toEpochSecond(ZoneOffset.UTC))
                        .setNanos(domain.calculatedAt.nano)
                        .build()

        return DailyAsset.newBuilder()
                .setAssetDate(assetDateTimestamp)
                .setTotalAssetValue(domain.totalAssetValue)
                .setAccountCount(domain.accountCount)
                .setCalculatedAt(calculatedAtTimestamp)
                .build()
    }

    /** Maps list of DailyUserAsset → GetDailyAssetsResponse */
    fun toProtoDailyAssetsResponse(domain: List<DailyUserAsset>): GetDailyAssetsResponse {
        val builder = GetDailyAssetsResponse.newBuilder()
        domain.forEach { asset -> builder.addDailyAssets(toProtoDailyAsset(asset)) }
        return builder.build()
    }

    /** Maps list of DailyUserAsset → GetLast7DaysAssetsResponse */
    fun toProtoLast7DaysResponse(domain: List<DailyUserAsset>): GetLast7DaysAssetsResponse {
        val builder = GetLast7DaysAssetsResponse.newBuilder()
        domain.forEach { asset -> builder.addDailyAssets(toProtoDailyAsset(asset)) }
        return builder.build()
    }

    /** Maps list of DailyUserAsset → GetLast6MonthsEndOfMonthAssetsResponse */
    fun toProtoLast6MonthsResponse(
            domain: List<DailyUserAsset>
    ): GetLast6MonthsEndOfMonthAssetsResponse {
        val builder = GetLast6MonthsEndOfMonthAssetsResponse.newBuilder()
        domain.forEach { asset -> builder.addDailyAssets(toProtoDailyAsset(asset)) }
        return builder.build()
    }
}
