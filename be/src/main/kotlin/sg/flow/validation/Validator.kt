package sg.flow.validation

import com.google.protobuf.Timestamp
import io.grpc.Status
import io.grpc.StatusRuntimeException
import java.time.Instant

import com.google.i18n.phonenumbers.PhoneNumberUtil
import com.google.i18n.phonenumbers.NumberParseException
import sg.flow.transfer.v1.TransferRequest

/** Wraps INVALID_ARGUMENT so it maps cleanly to HTTP 400 in grpc‑json. */
class ValidationException(message: String) :
    StatusRuntimeException(Status.INVALID_ARGUMENT.withDescription(message))

/** Idiomatic one‑liner validation helpers. */
object Validator {

    /* ── Generic helpers ── */

    fun require(condition: Boolean, message: String) {
        if (!condition) throw ValidationException(message)
    }

    fun notBlank(value: String, field: String): String {
        require(value.isNotBlank(), "$field cannot be blank")
        return value
    }

    fun lengthBetween(value: String, min: Int, max: Int, field: String): String {
        require(value.length in min..max, "$field must be between $min and $max characters")
        return value
    }

    fun exactLength(value: String, length: Int, field: String): String {
        require(value.length == length, "$field must be exactly $length characters")
        return value
    }

    fun positive(value: Long, field: String): Long {
        require(value > 0, "$field must be positive")
        return value
    }

    fun positive(value: Int, field: String): Int {
        require(value > 0, "$field must be positive")
        return value
    }

    fun positive(value: Double, field: String): Double {
        require(value > 0, "$field must be positive")
        return value
    }

    /* ── Optional (nullable) helpers ── */

    fun optionalNotBlank(value: String?, field: String): String? {
        return value?.also { notBlank(it, field) }
    }

    fun optionalLengthBetween(value: String?, min: Int, max: Int, field: String): String? {
        return value?.also { lengthBetween(it, min, max, field) }
    }

    fun optionalExactLength(value: String?, length: Int, field: String): String? {
        return value?.also { exactLength(it, length, field) }
    }

    /* ── Domain‑specific shortcuts ── */

    fun validateUsername(username: String) =
        lengthBetween(notBlank(username, "Username"), 1, 100, "Username")

    fun validatePassword(password: String) {
        lengthBetween(notBlank(password, "Password"), 6, 100, "Password")
    }

    fun validateRefreshToken(token: String) =
        exactLength(notBlank(token, "Refresh token"), 64, "Refresh token")

    fun validateEmail(email: String) {
        val pattern =
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\$".toRegex(RegexOption.IGNORE_CASE)
        require(pattern.matches(email), "Email format is invalid")
    }

    fun validatePhoneNumber(phoneNumber: String) {
        val util = PhoneNumberUtil.getInstance()
        val REGION_SG = "SG"
        try {
            val phoneNumber = util.parse(phoneNumber, REGION_SG)
            util.isValidNumber(phoneNumber)
        } catch (e: NumberParseException) {
            require(false, "PhoneNumber format is invalid: ${e.message}")
        }
    }

    fun validateAddress(address: String) {
        // LEFT BLANK FOR NOW
    }

    fun validateAccountId(id: Long) {
        positive(id, "Account ID")
    }

    fun validateYear(year: Int) {
        require(year > 2000 && year < 2050,  "Year must be greater than or equal to 2000, and smaller than 2050: Provided year: $year")
    }

    fun validateMonth(month: Int) {
        require(month > 0 && month <= 12,  "Month must be between 1 and 12: Provided month: $month")
    }

    fun validateDayOfMonth(dayOfMonth: Int) {
        require(dayOfMonth > 0 && dayOfMonth <= 31, "Day must be greater than or equal to 31: Provided day: $dayOfMonth")
    }

    fun validateStringValidLong(str: String) {
        require(str.toLongOrNull() != null, "The String value must be castable to a Long: Provided String: $str")
    }

    fun validateTimestamp(timestamp: Timestamp) {
        val LOWER_BOUND: Instant = Instant.parse("2000-01-01T00:00:00Z")
        val UPPER_BOUND: Instant = Instant.parse("2050-12-31T23:59:59.999999999Z")

        val timestampCasted = Instant.ofEpochSecond(timestamp.seconds, timestamp.nanos.toLong())
        require((!timestampCasted.isBefore(LOWER_BOUND)) && (!timestampCasted.isAfter(UPPER_BOUND)), "The timestamp cannot be before year 2000, and after year 2050")
    }

    fun validateStartTimestampIsNotAfterEndTimestamp(startTimestamp: Timestamp, endTimestamp: Timestamp) {
        val startCasted = Instant.ofEpochSecond(startTimestamp.seconds, startTimestamp  .nanos.toLong())
        val endCasted = Instant.ofEpochSecond(endTimestamp.seconds, endTimestamp.nanos.toLong())
        require(!endCasted.isAfter(startCasted), "The start timestamp cannot be after end timestamp")
    }

    fun validateTransferRequest(transferRequest: TransferRequest) {
        // LEFT AS EMPTY FOR NOW
    }

    fun validateAccountNumberKeyword(accountNumberKeyword: String) {
        // LEFT AS EMPTY FOR NOW
    }

    fun validateContactKeyword(contactKeyword: String) {
        // LEFT AS EMPTY FOR NOW
    }
}
