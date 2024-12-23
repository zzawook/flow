package sg.toss_sg.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import sg.toss_sg.entities.Account;

@Repository
public interface AccountRepository extends JpaRepository<Account, Long> {
    
}
