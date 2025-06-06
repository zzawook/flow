package sg.flow

import org.junit.jupiter.api.Assertions.assertNotNull
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest

@SpringBootTest
@org.springframework.test.context.ActiveProfiles("test")
class FlowApplicationTests {

    @Autowired private lateinit var flowApplication: FlowApplication

    @Test
    fun contextLoads() {
        assertNotNull(flowApplication)
    }
}
