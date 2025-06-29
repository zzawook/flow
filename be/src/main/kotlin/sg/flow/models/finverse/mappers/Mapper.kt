package sg.flow.models.finverse.mappers

interface Mapper<A, B> {
    fun map(input: A): B
}