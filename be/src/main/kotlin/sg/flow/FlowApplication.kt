package sg.flow

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.context.properties.ConfigurationPropertiesScan
import org.springframework.boot.runApplication

@SpringBootApplication
@ConfigurationPropertiesScan
class FlowApplication

fun main(args: Array<String>) {
    runApplication<FlowApplication>(*args)
}
