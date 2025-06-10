package sg.flow.validation

import io.grpc.Status
import io.grpc.StatusRuntimeException

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

    fun validatePassword(password: String) =
        lengthBetween(notBlank(password, "Password"), 6, 100, "Password")

    fun validateRefreshToken(token: String) =
        exactLength(notBlank(token, "Refresh token"), 64, "Refresh token")

    fun validateEmail(email: String) {
        val pattern =
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\$".toRegex(RegexOption.IGNORE_CASE)
        require(pattern.matches(email), "Email format is invalid")
    }
}
