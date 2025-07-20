package sg.flow.models.finverse

enum class FinverseRetrievalStatus {
    NOT_YET,
    RETRIEVED,
    RETRIEVAL_FAILED,
    PARTIALLY_RETRIEVED,
    NOT_FOUND,
    NOT_SUPPORTED,
    TEMPORARILY_UNAVAILABLE_FOR_INSTITUTION
}