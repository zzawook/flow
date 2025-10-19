package sg.flow.grpc.mapper

import com.google.protobuf.StringValue
import com.google.protobuf.Timestamp
import org.springframework.stereotype.Component
import java.time.LocalDate
import java.time.LocalDateTime
import sg.flow.models.user.UpdateUserProfile as DomainUpdateUserProfile
import sg.flow.user.v1.UpdateUserProfileRequest as ProtoUpdateUserProfileRequest
import sg.flow.user.v1.UserProfile as ProtoUserProfile
import sg.flow.models.user.UserProfile as DomainUserProfile
import java.time.ZoneOffset

@Component
class UserMapper {
    fun toProto(domain: DomainUserProfile): ProtoUserProfile =
        ProtoUserProfile.newBuilder()
            .setId(domain.id)
            .setName(domain.name)
            .setEmail(domain.email)
            .setIdentificationNumber(domain.identificationNumber)
            .setPhoneNumber(domain.phoneNumber)
            .setDateOfBirth(
                if (domain.dateOfBirth == null) {
                    Timestamp.newBuilder().setSeconds(LocalDateTime.now().toEpochSecond(ZoneOffset.UTC)).build()
                } else {
                    Timestamp.newBuilder()
                        // Convert LocalDate at start of day UTC to epoch seconds
                        .setSeconds(domain.dateOfBirth.atStartOfDay(ZoneOffset.UTC).toEpochSecond())
                        .setNanos(0)
                        .build()
                }
            )
            .also { if (domain.settingJson != null) it.settingJson = StringValue.of(domain.settingJson) }
            .build()

    fun toDomain(proto: ProtoUpdateUserProfileRequest): DomainUpdateUserProfile =
        DomainUpdateUserProfile(
            name                  = if (proto.hasName()) proto.name else null,
            email                 = if (proto.hasEmail()) proto.email else null,
            identificationNumber  = if (proto.hasIdentificationNumber()) proto.identificationNumber else null,
            phoneNumber           = if (proto.hasPhoneNumber()) proto.phoneNumber else null,
            settingsJson          = if (proto.hasSettingsJson()) proto.settingsJson else null,
        )

}