package sg.flow.models.auth

import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.userdetails.UserDetails

class FlowUserDetails(
        val userId: Int,
        private val name: String,
        private val authoritiesSet: Collection<GrantedAuthority>
) : UserDetails {

    override fun getAuthorities(): Collection<GrantedAuthority> = authoritiesSet

    override fun getPassword(): String = "SampleFlowPassword"

    override fun getUsername(): String = name

    override fun isAccountNonExpired(): Boolean = true
    override fun isAccountNonLocked(): Boolean = true
    override fun isCredentialsNonExpired(): Boolean = true
    override fun isEnabled(): Boolean = true
}
