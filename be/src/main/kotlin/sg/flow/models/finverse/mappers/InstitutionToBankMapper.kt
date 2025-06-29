package sg.flow.models.finverse.mappers

import org.springframework.stereotype.Component
import sg.flow.entities.Bank
import sg.flow.models.finverse.FinverseInstitution
import sg.flow.models.finverse.mappers.Mapper

@Component
class InstitutionToBankMapper : Mapper<FinverseInstitution, Bank> {
    override fun map(input: FinverseInstitution): Bank {
        TODO("Not yet implemented")
    }

}