package sg.flow.models.finverse

enum class FinverseAuthenticationStatus(
    val success: Boolean,
    val message: String,
) {
    AUTHENTICATED(true, ""),
    FAILED(false, "AUTHENTICATION FAILED"),
    TEMPORARILY_UNAVAILABLE_FOR_INSTITUTION(false, "AUTHENTICATION TEMPORARY UNAVAILABLE"),
    TOO_MANY_ATTEMPTS(false, "AUTHENTICATION TOO MANY ATTEMPTS"),
    TIMEOUT(false, "AUTHENTICATION TIMEOUT"),
}