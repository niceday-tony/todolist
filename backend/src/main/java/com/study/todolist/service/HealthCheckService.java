package com.study.todolist.service;

import com.study.todolist.dto.HealthCheckResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.Connection;
import java.time.LocalDateTime;

@Service
public class HealthCheckService {

    private final DataSource dataSource;

    @Autowired
    public HealthCheckService(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public HealthCheckResponse checkHealth() {
        String databaseStatus = checkDatabaseConnection();

        return HealthCheckResponse.builder()
                .status("UP")
                .database(databaseStatus)
                .timestamp(LocalDateTime.now())
                .build();
    }

    private String checkDatabaseConnection() {
        try (Connection connection = dataSource.getConnection()) {
            if (connection.isValid(2)) {
                return "UP";
            }
        } catch (Exception e) {
            // 로그에 에러 기록
            return "DOWN";
        }
        return "DOWN";
    }
}