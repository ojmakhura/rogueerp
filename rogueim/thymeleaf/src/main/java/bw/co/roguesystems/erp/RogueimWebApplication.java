package bw.co.roguesystems.erp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Import;

@SpringBootApplication
@Import(SharedAutoConfiguration.class)
public class RogueimWebApplication {
    public static void main(String[] args) {
        SpringApplication.run(RogueimWebApplication.class, args);
    }
}