package sg.flow.grpc.mapper

import com.google.protobuf.Timestamp
import org.springframework.stereotype.Component
import java.time.Instant
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.ZoneOffset

@Component
class DateTimeMapper {
    fun toTimestamp(dateTime: LocalDateTime): Timestamp =
        Timestamp.newBuilder()
            .setSeconds(dateTime.toEpochSecond(ZoneOffset.UTC))
            .setNanos(dateTime.nano)
            .build()

    /** helper to convert incoming protobuf Timestamp → LocalDate */
    fun toLocalDate(timestamp: Timestamp): LocalDate =
        Instant.ofEpochSecond(timestamp.seconds, timestamp.nanos.toLong())
            .atZone(ZoneOffset.UTC)
            .toLocalDate()

}