package sg.flow.repositories.dailyAsset

import java.time.LocalDate
import sg.flow.entities.DailyUserAsset

interface DailyAssetRepository {
    /**
     * Calculate and store daily assets for all users for a specific date. Returns the number of
     * users processed.
     */
    suspend fun calculateAndStoreDailyAssetsForDate(date: LocalDate): Int

    /** Find asset value for a specific user on a specific date */
    suspend fun findByUserAndDate(userId: Int, date: LocalDate): DailyUserAsset?

    /** Find asset values for a specific user within a date range (inclusive) */
    suspend fun findByUserAndDateRange(
            userId: Int,
            startDate: LocalDate,
            endDate: LocalDate
    ): List<DailyUserAsset>

    /** Find all user IDs that are missing asset data for a specific date */
    suspend fun findUsersMissingAssetsForDate(date: LocalDate): List<Int>
}
