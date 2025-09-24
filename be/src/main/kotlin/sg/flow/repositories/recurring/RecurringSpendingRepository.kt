package sg.flow.repositories.recurring

import sg.flow.entities.RecurringSpendingMonthly

interface RecurringSpendingRepository {
    suspend fun upsertAll(records: List<RecurringSpendingMonthly>): Int
    suspend fun deleteForUserFrom(userId: Int, startYear: Int, startMonth: Int): Boolean
    suspend fun findRecurringTransactionsForUserId(userId: Int): List<RecurringSpendingMonthly>
}
