package sg.flow.repositories.spendingMedian

import sg.flow.entities.SpendingMedianByAgeGroup

interface SpendingMedianRepository {
    suspend fun findByAgeGroupAndYearMonth(
            ageGroup: String,
            year: Int,
            month: Int
    ): SpendingMedianByAgeGroup?

    suspend fun upsertMedian(
            ageGroup: String,
            year: Int,
            month: Int,
            medianSpending: Double,
            userCount: Int,
            transactionCount: Int
    ): Int

    suspend fun findMissingMonths(
            startYear: Int,
            startMonth: Int,
            endYear: Int,
            endMonth: Int
    ): List<Pair<Int, Int>>

    suspend fun calculateAndStoreMediansForMonth(year: Int, month: Int): Int
}
