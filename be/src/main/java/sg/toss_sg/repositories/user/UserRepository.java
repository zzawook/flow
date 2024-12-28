package sg.toss_sg.repositories.user;

import org.springframework.stereotype.Repository;

import sg.toss_sg.entities.User;

@Repository
public interface UserRepository extends sg.toss_sg.repositories.Repository<User, Long> {
}
