package sg.toss_sg.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import sg.toss_sg.entities.Bank;

@Repository
public interface BankRepository extends JpaRepository<Bank, Long> {
    
}
