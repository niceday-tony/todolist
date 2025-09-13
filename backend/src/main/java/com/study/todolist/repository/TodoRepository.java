package com.study.todolist.repository;

import com.study.todolist.model.Todo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TodoRepository extends JpaRepository<Todo, Long> {

    List<Todo> findByPlantIdOrderByCreatedAtDesc(Long plantId);

    List<Todo> findByCompletedOrderByCreatedAtDesc(Boolean completed);

    long countByPlantIdAndCompleted(Long plantId, Boolean completed);
}