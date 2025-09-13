package com.study.todolist.service;

import com.study.todolist.dto.request.TodoCreateRequest;
import com.study.todolist.dto.request.TodoUpdateRequest;
import com.study.todolist.dto.response.TodoResponse;
import com.study.todolist.model.Todo;
import com.study.todolist.model.Plant;
import com.study.todolist.repository.TodoRepository;
import com.study.todolist.repository.PlantRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class TodoService {

    private final TodoRepository todoRepository;
    private final PlantRepository plantRepository;

    public TodoService(TodoRepository todoRepository, PlantRepository plantRepository) {
        this.todoRepository = todoRepository;
        this.plantRepository = plantRepository;
    }

    @Transactional
    public TodoResponse createTodo(TodoCreateRequest request) {
        // Plant 존재 확인
        Plant plant = plantRepository.findById(request.getPlantId())
                .orElseThrow(() -> new RuntimeException("Plant not found with id: " + request.getPlantId()));

        Todo todo = new Todo(
                request.getTitle(),
                request.getDescription(),
                request.getPlantId()
        );

        Todo savedTodo = todoRepository.save(todo);
        return toTodoResponse(savedTodo);
    }

    public List<TodoResponse> getTodosByPlant(Long plantId) {
        List<Todo> todos = todoRepository.findByPlantIdOrderByCreatedAtDesc(plantId);
        return todos.stream()
                .map(this::toTodoResponse)
                .collect(Collectors.toList());
    }

    public List<TodoResponse> getAllTodos() {
        List<Todo> todos = todoRepository.findAll();
        return todos.stream()
                .map(this::toTodoResponse)
                .collect(Collectors.toList());
    }

    @Transactional
    public TodoResponse updateTodo(Long id, TodoUpdateRequest request) {
        Todo todo = todoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Todo not found with id: " + id));

        todo.setTitle(request.getTitle());
        todo.setDescription(request.getDescription());

        Todo updatedTodo = todoRepository.save(todo);
        return toTodoResponse(updatedTodo);
    }

    @Transactional
    public void deleteTodo(Long id) {
        Todo todo = todoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Todo not found with id: " + id));

        todoRepository.delete(todo);
    }

    @Transactional
    public TodoResponse completeTodo(Long id) {
        Todo todo = todoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Todo not found with id: " + id));

        // Toggle completion status
        boolean newCompletedStatus = !todo.getCompleted();
        todo.setCompleted(newCompletedStatus);

        if (newCompletedStatus) {
            todo.setCompletedAt(LocalDateTime.now());
            // TODO: Plant growth logic will be added in Story 1.3
        } else {
            todo.setCompletedAt(null);
        }

        Todo updatedTodo = todoRepository.save(todo);
        return toTodoResponse(updatedTodo);
    }

    public TodoResponse getTodoById(Long id) {
        Todo todo = todoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Todo not found with id: " + id));
        return toTodoResponse(todo);
    }

    private TodoResponse toTodoResponse(Todo todo) {
        return new TodoResponse(
                todo.getId(),
                todo.getTitle(),
                todo.getDescription(),
                todo.getCompleted(),
                todo.getCompletedAt(),
                todo.getCreatedAt(),
                todo.getUpdatedAt(),
                todo.getPlantId()
        );
    }
}