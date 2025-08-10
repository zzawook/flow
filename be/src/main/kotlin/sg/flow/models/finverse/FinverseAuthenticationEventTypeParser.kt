package sg.flow.models.finverse

object FinverseAuthenticationEventTypeParser {
    private val regex = Regex("""^([A-Z_]+?)_([A-Z_]+)$""")
    fun parse(raw: String): FinverseAuthenticationStatus? {
        if (raw == "AUTHENTICATED") {
            return FinverseAuthenticationStatus.AUTHENTICATED
        }
        regex.matchEntire(raw)?.let { m ->
            val status   = FinverseAuthenticationStatus.valueOf(m.groupValues[2])
            return status
        }
        return FinverseAuthenticationStatus.FAILED
    }

}