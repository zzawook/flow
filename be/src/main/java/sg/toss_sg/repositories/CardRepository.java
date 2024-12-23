package sg.toss_sg.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import sg.toss_sg.entities.Card;

@Repository
public interface CardRepository extends JpaRepository<Card, Long> {
    
}
