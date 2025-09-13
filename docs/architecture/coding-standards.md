# Coding Standards

## Overview

TodoList 프로젝트의 코딩 표준 및 개발 패턴을 정의합니다. **5명 개발자 협업 일관성**을 보장합니다.

## General Principles

### Core Values
1. **단순성 우선**: 복잡한 패턴보다 단순하고 명확한 코드
2. **일관성**: 팀 전체가 동일한 패턴 사용
3. **가독성**: 코드는 문서가 되어야 함
4. **테스트 가능성**: 모든 로직은 테스트 가능하게 설계

### Code Organization
- **단일 책임 원칙**: 하나의 클래스/함수는 하나의 책임
- **의존성 주입**: Spring DI 적극 활용
- **레이어 분리**: Presentation → Business → Data 명확히 구분

## Backend Coding Standards (Java/Spring Boot)

### Package Structure
```
com.study.todolist/
├── controller/          # REST Controllers
├── service/            # Business Logic
├── repository/         # Data Access
├── model/             # JPA Entities
├── dto/               # Request/Response DTOs
├── config/            # Spring Configuration
└── TodolistApplication.java
```

### Naming Conventions

#### Classes & Interfaces
```java
// Controllers - {Entity}Controller
@RestController
public class TodoController {
    // GET, POST, PUT, DELETE
}

// Services - {Entity}Service
@Service
public class TodoService {
    // 비즈니스 로직
}

// Repositories - {Entity}Repository
public interface TodoRepository extends JpaRepository<Todo, Long> {
    // 쿼리 메서드
}

// Entities - {Entity} (단수형)
@Entity
public class Todo {
    // 필드, getter, setter
}

// DTOs - {Entity}{Operation}Dto
public class TodoCreateDto {
    // 요청/응답 데이터
}
```

#### Variables & Methods
```java
// 카멜케이스 사용
private String todoTitle;
private LocalDateTime createdAt;

// 메서드명: 동사 + 명사
public Todo createTodo(TodoCreateDto dto) { }
public List<Todo> findAllTodos() { }
public void updateTodo(Long id, TodoUpdateDto dto) { }
public void deleteTodo(Long id) { }
```

### JPA Entity Patterns

```java
@Entity
@Table(name = "todos")
public class Todo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "title", nullable = false, length = 255)
    private String title;

    @Column(name = "description", length = 1000)
    private String description;

    @Column(name = "completed", nullable = false)
    private Boolean completed = false;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "plant_id", nullable = false)
    private Plant plant;

    // 기본 생성자, getter, setter
}
```

### Service Layer Patterns

```java
@Service
@Transactional(readOnly = true)
public class TodoService {

    private final TodoRepository todoRepository;
    private final PlantService plantService;

    public TodoService(TodoRepository todoRepository, PlantService plantService) {
        this.todoRepository = todoRepository;
        this.plantService = plantService;
    }

    @Transactional  // 쓰기 작업에만 readOnly = false
    public Todo createTodo(TodoCreateDto dto) {
        Todo todo = new Todo();
        todo.setTitle(dto.getTitle());
        todo.setDescription(dto.getDescription());
        todo.setCompleted(false);

        return todoRepository.save(todo);
    }

    @Transactional
    public Todo completeTodo(Long id) {
        Todo todo = findTodoById(id);
        todo.setCompleted(true);
        todo.setCompletedAt(LocalDateTime.now());

        // 식물 성장 로직 (동일 트랜잭션)
        plantService.growPlant(todo.getPlant().getId());

        return todoRepository.save(todo);
    }
}
```

### Controller Layer Patterns

```java
@RestController
@RequestMapping("/api/todos")
public class TodoController {

    private final TodoService todoService;

    public TodoController(TodoService todoService) {
        this.todoService = todoService;
    }

    @GetMapping
    public ResponseEntity<List<TodoResponseDto>> getAllTodos() {
        List<Todo> todos = todoService.findAllTodos();
        List<TodoResponseDto> response = todos.stream()
            .map(this::toResponseDto)
            .toList();
        return ResponseEntity.ok(response);
    }

    @PostMapping
    public ResponseEntity<TodoResponseDto> createTodo(@Valid @RequestBody TodoCreateDto dto) {
        Todo todo = todoService.createTodo(dto);
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(toResponseDto(todo));
    }

    @PutMapping("/{id}/complete")
    public ResponseEntity<TodoResponseDto> completeTodo(@PathVariable Long id) {
        Todo todo = todoService.completeTodo(id);
        return ResponseEntity.ok(toResponseDto(todo));
    }
}
```

## Frontend Coding Standards (React/TypeScript)

### Component Structure
```typescript
// components/todo/TodoItem/TodoItem.tsx
import React from 'react';
import styles from './TodoItem.module.css';

interface TodoItemProps {
  todo: Todo;
  onComplete: (id: number) => void;
  onDelete: (id: number) => void;
}

export const TodoItem: React.FC<TodoItemProps> = ({
  todo,
  onComplete,
  onDelete
}) => {
  const handleComplete = () => {
    onComplete(todo.id);
  };

  return (
    <div className={styles.todoItem}>
      <h3 className={styles.title}>{todo.title}</h3>
      <p className={styles.description}>{todo.description}</p>
      <button
        className={styles.completeButton}
        onClick={handleComplete}
        disabled={todo.completed}
      >
        {todo.completed ? '완료됨' : '완료하기'}
      </button>
    </div>
  );
};
```

### TypeScript Types

```typescript
// types/Todo.ts
export interface Todo {
  id: number;
  title: string;
  description: string;
  completed: boolean;
  completedAt: string | null;
  createdAt: string;
  updatedAt: string;
  plantId: number;
}

export interface TodoCreateRequest {
  title: string;
  description: string;
  plantId: number;
}

export interface Plant {
  id: number;
  name: string;
  species: string;
  growthPoints: number;
  currentStage: number;
  createdAt: string;
  lastInteractionAt: string;
}
```

### API Service Pattern

```typescript
// services/todoService.ts
import axios from 'axios';
import { Todo, TodoCreateRequest } from '../types/Todo';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080';

const apiClient = axios.create({
  baseURL: `${API_BASE_URL}/api`,
  headers: {
    'Content-Type': 'application/json',
  },
});

export const todoService = {
  async getAllTodos(): Promise<Todo[]> {
    const response = await apiClient.get<Todo[]>('/todos');
    return response.data;
  },

  async createTodo(todo: TodoCreateRequest): Promise<Todo> {
    const response = await apiClient.post<Todo>('/todos', todo);
    return response.data;
  },

  async completeTodo(id: number): Promise<Todo> {
    const response = await apiClient.put<Todo>(`/todos/${id}/complete`);
    return response.data;
  },
};
```

### Custom Hooks Pattern

```typescript
// hooks/useTodos.ts
import { useState, useEffect } from 'react';
import { Todo, TodoCreateRequest } from '../types/Todo';
import { todoService } from '../services/todoService';

export const useTodos = () => {
  const [todos, setTodos] = useState<Todo[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchTodos = async () => {
    try {
      setLoading(true);
      const fetchedTodos = await todoService.getAllTodos();
      setTodos(fetchedTodos);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error');
    } finally {
      setLoading(false);
    }
  };

  const createTodo = async (todoData: TodoCreateRequest) => {
    try {
      const newTodo = await todoService.createTodo(todoData);
      setTodos(prev => [...prev, newTodo]);
      return newTodo;
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to create todo');
      throw err;
    }
  };

  useEffect(() => {
    fetchTodos();
  }, []);

  return {
    todos,
    loading,
    error,
    createTodo,
    refetch: fetchTodos
  };
};
```

## Error Handling Standards

### Backend Error Handling
```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(EntityNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(EntityNotFoundException ex) {
        ErrorResponse error = new ErrorResponse("NOT_FOUND", ex.getMessage());
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    @ExceptionHandler(ValidationException.class)
    public ResponseEntity<ErrorResponse> handleValidation(ValidationException ex) {
        ErrorResponse error = new ErrorResponse("VALIDATION_ERROR", ex.getMessage());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
    }
}
```

### Frontend Error Handling
```typescript
// utils/errorHandler.ts
export const handleApiError = (error: unknown): string => {
  if (axios.isAxiosError(error)) {
    if (error.response?.data?.message) {
      return error.response.data.message;
    }
    return `HTTP ${error.response?.status}: ${error.message}`;
  }

  return error instanceof Error ? error.message : 'Unknown error occurred';
};
```

## Testing Standards

### Backend Testing
```java
@SpringBootTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class TodoServiceTest {

    @Autowired
    private TodoService todoService;

    @Test
    void createTodo_ValidData_ReturnsTodo() {
        // Given
        TodoCreateDto dto = new TodoCreateDto();
        dto.setTitle("Test Todo");
        dto.setDescription("Test Description");

        // When
        Todo result = todoService.createTodo(dto);

        // Then
        assertThat(result.getTitle()).isEqualTo("Test Todo");
        assertThat(result.getCompleted()).isFalse();
    }
}
```

### Frontend Testing
```typescript
// components/todo/TodoItem/TodoItem.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { TodoItem } from './TodoItem';

describe('TodoItem', () => {
  const mockTodo = {
    id: 1,
    title: 'Test Todo',
    description: 'Test Description',
    completed: false,
    completedAt: null,
    createdAt: '2025-09-14T00:00:00',
    updatedAt: '2025-09-14T00:00:00',
    plantId: 1
  };

  it('calls onComplete when complete button is clicked', () => {
    const mockOnComplete = jest.fn();
    const mockOnDelete = jest.fn();

    render(
      <TodoItem
        todo={mockTodo}
        onComplete={mockOnComplete}
        onDelete={mockOnDelete}
      />
    );

    const completeButton = screen.getByText('완료하기');
    fireEvent.click(completeButton);

    expect(mockOnComplete).toHaveBeenCalledWith(1);
  });
});
```

## Code Quality Requirements

### Mandatory Checks
1. **ESLint**: 모든 frontend 코드
2. **TypeScript**: strict mode 준수
3. **Unit Tests**: 모든 service 로직
4. **Integration Tests**: API 엔드포인트

### Performance Standards
- **백엔드**: API 응답 < 200ms
- **프론트엔드**: 첫 렌더링 < 1초, 애니메이션 60fps
- **메모리**: 메모리 누수 없음

### Security Standards
- **입력 검증**: 모든 사용자 입력 검증
- **SQL Injection 방지**: JPA 쿼리 사용
- **XSS 방지**: 출력 이스케이핑
- **CORS**: 명시적 허용 도메인만

이 표준을 준수하여 일관되고 유지보수 가능한 코드를 작성하세요.