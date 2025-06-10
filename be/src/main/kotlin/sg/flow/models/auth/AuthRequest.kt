package sg.flow.models.auth

import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.Size

data class AuthRequest(
    @field:NotBlank(message="Username cannot be blank")
    @field:Size(min = 1, max = 100, message = "Username must be between 1 and 100 characters")
    var username: String,

    @field:NotBlank(message="Password cannot be blank")
    @field:Size(min = 6, max = 100, message = "Password must be between 6 and 100 characters")
    var password: String)
