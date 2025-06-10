package sg.flow.grpc.mapper

import org.springframework.stereotype.Component
import sg.flow.auth.v1.TokenSet
import sg.flow.models.auth.TokenSet as DomainTokenSet

@Component
class AuthMapper {
    fun toProto(tokenSet: DomainTokenSet): TokenSet =
        TokenSet.newBuilder()
            .setAccessToken(tokenSet.accessToken)
            .setRefreshToken(tokenSet.refreshToken)
            .build()

}