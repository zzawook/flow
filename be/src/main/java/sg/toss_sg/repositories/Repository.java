package sg.toss_sg.repositories;

import java.util.Optional;

public interface Repository<T, S> {
    
    public T save(T entity);

    public Optional<T> findById(S id);

    public boolean deleteAll();
}
