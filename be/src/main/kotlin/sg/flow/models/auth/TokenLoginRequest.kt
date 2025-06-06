package sg.flow.models.auth

data class TokenLoginRequest(var tokenType: String, var tokenValue: String)
