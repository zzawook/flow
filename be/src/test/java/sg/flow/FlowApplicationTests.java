package sg.flow;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import sg.flow.FlowApplication;

import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest
class FlowApplicationTests {

        @Autowired
        private FlowApplication flowApplication;

        @Test
        void contextLoads() {
                assertNotNull(flowApplication);
        }

}
