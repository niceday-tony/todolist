package com.study.todolist.controller;

import com.study.todolist.dto.HealthCheckResponse;
import com.study.todolist.service.HealthCheckService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/health")
public class HealthController {

    private final HealthCheckService healthCheckService;

    @Autowired
    public HealthController(HealthCheckService healthCheckService) {
        this.healthCheckService = healthCheckService;
    }

    @GetMapping
    public ResponseEntity<HealthCheckResponse> healthCheck() {
        HealthCheckResponse response = healthCheckService.checkHealth();
        return ResponseEntity.ok(response);
    }
}