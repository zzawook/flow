package sg.flow.models.auth

import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.Size

data class AccessTokenRefreshRequest(
    @field:NotBlank(message="Refresh Token cannot be blank")
    @field:Size(min = 64, max = 64, message = "Refresh Token should be of size 64")
    var refreshToken: String
)
