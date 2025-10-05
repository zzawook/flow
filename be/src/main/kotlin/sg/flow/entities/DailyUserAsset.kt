package sg.flow.entities

import jakarta.validation.constraints.NotNull
import java.time.LocalDate
import java.time.LocalDateTime
import org.springframework.data.annotation.Id

data class DailyUserAsset(
        @field:Id val id: Long?,
        @field:NotNull val userId: Int,
        @field:NotNull val assetDate: LocalDate,
        @field:NotNull val totalAssetValue: Double,
        @field:NotNull val accountCount: Int,
        @field:NotNull val calculatedAt: LocalDateTime = LocalDateTime.now()
)
