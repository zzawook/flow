package sg.flow.services.BankQueryServices.FinverseQueryService

class FinverseQueryService {
    private val credentials = FinverseCredentials()

    suspend fun linkInstitution(institutionId: String) {
        val url = "https://api.finverse.com/v1/institutions/$institutionId/link"
        val clientId = credentials.clientId
        val clientAppId = credentials.clientAppId
        val clientSecret = credentials.clientSecret
        
        // TODO: Implement actual linking logic
    }
} 