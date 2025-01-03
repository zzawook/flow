package sg.toss_sg.models.auth;

import java.util.Collection;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class FlowUserDetails implements UserDetails {

    private final int userId;
    private final String name;
    private final Collection<? extends GrantedAuthority> authorities;

    public FlowUserDetails(int userId, String name, Collection<? extends GrantedAuthority> authorities) {
        this.userId = userId;
        this.name = name;
        this.authorities = authorities;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return this.authorities;
    }

    @Override
    public String getPassword() {
        return "SampleFlowPassword";
    }

    @Override
    public String getUsername() {
        return this.name;
    }

    public int getUserId() {
        return userId;
    }

}
