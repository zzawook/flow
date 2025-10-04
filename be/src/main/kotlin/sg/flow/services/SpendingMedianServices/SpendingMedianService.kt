package sg.flow.services.SpendingMedianServices

import java.time.LocalDate
import java.time.Period
import java.time.ZoneId
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import sg.flow.entities.SpendingMedianByAgeGroup
import sg.flow.repositories.spendingMedian.SpendingMedianRepository
import sg.flow.repositories.user.UserRepository

@Service
class SpendingMedianService(
        private val spendingMedianRepository: SpendingMedianRepository,
        private val userRepository: UserRepository
) {

    private val logger = LoggerFactory.getLogger(SpendingMedianService::class.java)
    private val sgtZone = ZoneId.of("Asia/Singapore")

    /**
     * Get spending median for a user's age group for a specific month. If year/month not provided,
     * uses current month in SGT.
     */
    suspend fun getSpendingMedianForUser(
            userId: Int,
            year: Int?,
            month: Int?
    ): SpendingMedianByAgeGroup? {
        // Get user to determine their age group
        val user =
                userRepository.findById(userId.toLong())
                        ?: throw IllegalArgumentException("User not found: $userId")

        if (user.dateOfBirth == null) {
            logger.warn("User {} has no date of birth, cannot determine age group", userId)
            throw IllegalArgumentException("User has no date of birth")
        }

        // Calculate age group
        val ageGroup = calculateAgeGroup(user.dateOfBirth)
        logger.debug("User {} is in age group {}", userId, ageGroup)

        // Determine which year/month to query
        val now = LocalDate.now(sgtZone)
        val queryYear = year ?: now.year
        val queryMonth = month ?: now.monthValue

        // Fetch the median for this age group and month
        val median =
                spendingMedianRepository.findByAgeGroupAndYearMonth(ageGroup, queryYear, queryMonth)

        if (median == null) {
            logger.info(
                    "No spending median found for age group {} in {}-{}",
                    ageGroup,
                    queryYear,
                    queryMonth
            )
        }

        return median
    }

    /**
     * Calculate age group from date of birth. Age groups: 0s, 10s, 20s, ..., 150s (capped at 150)
     */
    private fun calculateAgeGroup(dateOfBirth: LocalDate): String {
        val now = LocalDate.now(sgtZone)
        val age = Period.between(dateOfBirth, now).years

        // Cap at 150 and round down to nearest decade
        val ageGroupNum = minOf(age / 10 * 10, 150)

        return "${ageGroupNum}s"
    }
}
