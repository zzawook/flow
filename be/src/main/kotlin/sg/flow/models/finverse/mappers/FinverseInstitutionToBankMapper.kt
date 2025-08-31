package sg.flow.models.finverse.mappers

import org.springframework.stereotype.Component
import sg.flow.entities.Bank
import sg.flow.models.finverse.FinverseInstitution

@Component
class FinverseInstitutionToBankMapper : Mapper<FinverseInstitution, Bank> {

    fun map(input: FinverseInstitution): Bank {
        val countriesString = ""
        input.countries.forEach { country -> countriesString.plus("$country,") }
        if (! countriesString.isEmpty()) {
            countriesString.substring(0, countriesString.length - 1)
        }
        return Bank(
                id = null, // Will be set by database
                name = input.parentInstitutionName ?: input.institutionName,
                bankCode = generateBankCode(input),
                finverseId = input.institutionId,
                countries = countriesString
        )
    }
    private fun generateBankCode(institution: FinverseInstitution): String {
        return institution.institutionId
    }
}
