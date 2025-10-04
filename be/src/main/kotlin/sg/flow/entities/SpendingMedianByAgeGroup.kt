package sg.flow.entities

import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull
import java.time.LocalDateTime
import org.springframework.data.annotation.Id

data class SpendingMedianByAgeGroup(
        @field:Id val id: Long?,
        @field:NotBlank val ageGroup: String,
        @field:NotNull val year: Int,
        @field:NotNull val month: Int,
        @field:NotNull val medianSpending: Double,
        @field:NotNull val userCount: Int,
        @field:NotNull val transactionCount: Int,
        @field:NotNull val calculatedAt: LocalDateTime = LocalDateTime.now()
)
