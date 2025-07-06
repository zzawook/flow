package sg.flow.models.finverse.mappers

import org.springframework.stereotype.Component
import sg.flow.entities.Bank
import sg.flow.models.finverse.FinverseInstitution

@Component
class FinverseInstitutionToBankMapper : Mapper<FinverseInstitution, Bank> {

    fun map(input: FinverseInstitution): Bank {
        return Bank(
                id = null, // Will be set by database
                name = input.institutionName,
                bankCode = generateBankCode(input),
                finverseId = input.institutionId
        )
    }

    /**
     * Generate a bank code from the institution data. Priority order:
     * 1. Use provided bank_code if available
     * 2. Use SWIFT code if available
     * 3. Use routing number if available
     * 4. Generate from institution_id as fallback
     */
    private fun generateBankCode(institution: FinverseInstitution): String {
        return when {
            !institution.bankCode.isNullOrBlank() -> institution.bankCode
            !institution.swiftCode.isNullOrBlank() -> institution.swiftCode
            !institution.routingNumber.isNullOrBlank() -> institution.routingNumber
            else -> generateCodeFromId(institution.institutionId)
        }
    }

    /**
     * Generate a bank code from institution ID by taking the first 8 characters and converting to
     * uppercase for consistency
     */
    private fun generateCodeFromId(institutionId: String): String {
        return institutionId
                .take(8)
                .uppercase()
                .padEnd(8, '0') // Pad with zeros if shorter than 8 characters
    }
}
