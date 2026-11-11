package com.example.backend.health;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

/** Plain unit test of the controller method, no server started. */
class HealthControllerTest {

    @Test
    void healthReportsUp() {
        assertThat(new HealthController().health()).containsEntry("status", "UP");
    }
}
