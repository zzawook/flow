package sg.flow.repositories

interface Repository<T, S> {
    suspend fun save(entity: T): T
    suspend fun findById(id: S): T?
    suspend fun deleteAll(): Boolean
} 