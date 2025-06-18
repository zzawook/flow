package sg.flow.models.finverse

object EventTypeParser {
    private val regex = Regex("""^([A-Z_]+?)_([A-Z_]+)$""")
    fun parse(raw: String): FinverseProductStatus? =
        regex.matchEntire(raw)?.let { m ->
            val product  = FinverseProduct.valueOf(m.groupValues[1])
            val status   = FinverseRetrievalStatus.valueOf(m.groupValues[2])
            FinverseProductStatus(product, status)
        }
}