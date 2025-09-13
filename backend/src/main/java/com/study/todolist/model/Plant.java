package com.study.todolist.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "plants")
@Getter
@Setter
@NoArgsConstructor
public class Plant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name", nullable = false, length = 100)
    private String name = "내 식물";

    @Column(name = "species", nullable = false, length = 100)
    private String species = "해바라기";

    @Column(name = "growth_points", nullable = false)
    private Integer growthPoints = 0;

    @Column(name = "current_stage", nullable = false)
    private Integer currentStage = 1;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "last_interaction_at")
    private LocalDateTime lastInteractionAt;

    @OneToMany(mappedBy = "plant", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Todo> todos = new ArrayList<>();

    public Plant(String name, String species) {
        this.name = name;
        this.species = species;
        this.growthPoints = 0;
        this.currentStage = 1;
        this.lastInteractionAt = LocalDateTime.now();
    }

    // 식물 성장 로직
    public void addGrowthPoints(int points) {
        this.growthPoints += points;
        updateStage();
        this.lastInteractionAt = LocalDateTime.now();
    }

    private void updateStage() {
        // 성장 알고리즘: stage = min(5, floor(growthPoints / 20) + 1)
        int newStage = Math.min(5, (this.growthPoints / 20) + 1);
        this.currentStage = newStage;
    }
}