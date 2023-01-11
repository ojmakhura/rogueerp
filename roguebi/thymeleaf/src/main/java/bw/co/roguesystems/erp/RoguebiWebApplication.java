package bw.co.roguesystems.erp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Import;

@SpringBootApplication
@Import(SharedAutoConfiguration.class)
public class RoguebiWebApplication {
    public static void main(String[] args) {
        SpringApplication.run(RoguebiWebApplication.class, args);
    }
}