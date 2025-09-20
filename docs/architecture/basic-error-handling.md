# 기본 에러 처리 가이드 (MVP)

## 개요

"감성적인 할일 목록" MVP를 위한 기본적이고 실용적인 에러 처리 가이드입니다. 하루 개발 목표에 맞춰 복잡성을 최소화하면서도 사용자 경험을 해치지 않는 수준의 에러 처리를 제공합니다.

## 🔧 백엔드 에러 처리

### 1. 글로벌 예외 처리기

```java
// src/main/java/com/study/todolist/exception/GlobalExceptionHandler.java
@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    // 할일 찾을 수 없음
    @ExceptionHandler(TodoNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleTodoNotFound(TodoNotFoundException ex) {
        log.warn("Todo not found: {}", ex.getMessage());

        ErrorResponse error = ErrorResponse.builder()
            .status("error")
            .error(ErrorDetail.builder()
                .code("TODO_NOT_FOUND")
                .message("요청한 할일을 찾을 수 없습니다.")
                .build())
            .timestamp(LocalDateTime.now())
            .build();

        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    // 유효성 검사 실패
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException ex) {
        log.warn("Validation failed: {}", ex.getMessage());

        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getFieldErrors().forEach(error ->
            errors.put(error.getField(), error.getDefaultMessage())
        );

        ErrorResponse error = ErrorResponse.builder()
            .status("error")
            .error(ErrorDetail.builder()
                .code("VALIDATION_ERROR")
                .message("입력 데이터가 올바르지 않습니다.")
                .details(errors)
                .build())
            .timestamp(LocalDateTime.now())
            .build();

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
    }

    // 일반적인 예외
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGeneral(Exception ex) {
        log.error("Unexpected error occurred", ex);

        ErrorResponse error = ErrorResponse.builder()
            .status("error")
            .error(ErrorDetail.builder()
                .code("INTERNAL_SERVER_ERROR")
                .message("서버 내부 오류가 발생했습니다.")
                .build())
            .timestamp(LocalDateTime.now())
            .build();

        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }
}
```

### 2. 에러 응답 DTO

```java
// src/main/java/com/study/todolist/dto/response/ErrorResponse.java
@Data
@Builder
public class ErrorResponse {
    private String status;              // "error"
    private ErrorDetail error;          // 에러 상세 정보
    private LocalDateTime timestamp;    // 발생 시간
}

@Data
@Builder
public class ErrorDetail {
    private String code;                    // 에러 코드
    private String message;                 // 사용자 친화적 메시지
    private Map<String, Object> details;    // 추가 상세 정보 (선택사항)
}
```

### 3. 커스텀 예외 클래스

```java
// src/main/java/com/study/todolist/exception/TodoNotFoundException.java
public class TodoNotFoundException extends RuntimeException {
    public TodoNotFoundException(Long id) {
        super("Todo not found with id: " + id);
    }

    public TodoNotFoundException(String message) {
        super(message);
    }
}

// src/main/java/com/study/todolist/exception/TodoValidationException.java
public class TodoValidationException extends RuntimeException {
    public TodoValidationException(String message) {
        super(message);
    }
}
```

### 4. 서비스 레이어 에러 처리

```java
// src/main/java/com/study/todolist/service/TodoService.java
@Service
@Slf4j
public class TodoService {

    private final TodoRepository todoRepository;

    public TodoResponse getTodoById(Long id) {
        log.info("Fetching todo with id: {}", id);

        Todo todo = todoRepository.findById(id)
            .orElseThrow(() -> new TodoNotFoundException(id));

        return TodoMapper.toResponse(todo);
    }

    public TodoResponse createTodo(TodoCreateRequest request) {
        log.info("Creating new todo: {}", request.getTitle());

        try {
            // 기본 유효성 검사
            if (request.getTitle() == null || request.getTitle().trim().isEmpty()) {
                throw new TodoValidationException("할일 제목은 필수입니다.");
            }

            Todo todo = Todo.builder()
                .title(request.getTitle().trim())
                .description(request.getDescription())
                .priority(request.getPriority() != null ? request.getPriority() : Priority.MEDIUM)
                .dueDate(request.getDueDate())
                .completed(false)
                .build();

            Todo savedTodo = todoRepository.save(todo);
            log.info("Todo created successfully with id: {}", savedTodo.getId());

            return TodoMapper.toResponse(savedTodo);

        } catch (Exception e) {
            log.error("Failed to create todo", e);
            throw new RuntimeException("할일 생성에 실패했습니다.");
        }
    }

    public TodoResponse toggleTodo(Long id) {
        log.info("Toggling todo completion: {}", id);

        Todo todo = todoRepository.findById(id)
            .orElseThrow(() -> new TodoNotFoundException(id));

        todo.setCompleted(!todo.getCompleted());
        Todo savedTodo = todoRepository.save(todo);

        log.info("Todo {} marked as {}", id, savedTodo.getCompleted() ? "completed" : "pending");
        return TodoMapper.toResponse(savedTodo);
    }
}
```

## 🎯 프론트엔드 에러 처리

### 1. API 서비스 에러 처리

```typescript
// src/services/todoService.ts
import axios, { AxiosError, AxiosResponse } from 'axios';

const API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL || 'http://localhost:8080/api';

// Axios 인스턴스 생성
const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
  timeout: 10000, // 10초 타임아웃
});

// 응답 인터셉터로 에러 처리
apiClient.interceptors.response.use(
  (response: AxiosResponse) => response,
  (error: AxiosError) => {
    console.error('API Error:', error);

    // 네트워크 에러
    if (!error.response) {
      throw new Error('네트워크 연결을 확인해주세요.');
    }

    // 서버 응답 에러
    const { status, data } = error.response;

    switch (status) {
      case 400:
        throw new Error(data?.error?.message || '잘못된 요청입니다.');
      case 404:
        throw new Error(data?.error?.message || '요청한 데이터를 찾을 수 없습니다.');
      case 500:
        throw new Error('서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
      default:
        throw new Error(data?.error?.message || '알 수 없는 오류가 발생했습니다.');
    }
  }
);

// API 함수들
export const todoService = {
  // 할일 목록 조회
  async getTodos(): Promise<Todo[]> {
    try {
      const response = await apiClient.get('/todos');
      return response.data.data || [];
    } catch (error) {
      console.error('Failed to fetch todos:', error);
      throw error;
    }
  },

  // 할일 생성
  async createTodo(todoData: TodoCreateRequest): Promise<Todo> {
    try {
      const response = await apiClient.post('/todos', todoData);
      return response.data.data;
    } catch (error) {
      console.error('Failed to create todo:', error);
      throw error;
    }
  },

  // 할일 완료 토글
  async toggleTodo(id: number): Promise<Todo> {
    try {
      const response = await apiClient.put(`/todos/${id}/toggle`);
      return response.data.data;
    } catch (error) {
      console.error('Failed to toggle todo:', error);
      throw error;
    }
  },

  // 할일 삭제
  async deleteTodo(id: number): Promise<void> {
    try {
      await apiClient.delete(`/todos/${id}`);
    } catch (error) {
      console.error('Failed to delete todo:', error);
      throw error;
    }
  }
};
```

### 2. 에러 토스트 컴포넌트

```typescript
// src/components/ErrorToast.tsx
import { useEffect } from 'react';
import { useTodoStore } from '../stores/todoStore';

export const ErrorToast: React.FC = () => {
  const { error, clearError } = useTodoStore();

  useEffect(() => {
    if (error) {
      // 5초 후 자동으로 에러 메시지 제거
      const timer = setTimeout(() => {
        clearError();
      }, 5000);

      return () => clearTimeout(timer);
    }
  }, [error, clearError]);

  if (!error) return null;

  return (
    <div className="error-toast">
      <div className="error-content">
        <span className="error-icon">⚠️</span>
        <span className="error-message">{error}</span>
        <button
          className="error-close"
          onClick={clearError}
          aria-label="에러 메시지 닫기"
        >
          ×
        </button>
      </div>
    </div>
  );
};
```

### 3. 로딩 및 에러 상태 처리

```typescript
// src/components/TodoList.tsx
import { useTodoStore } from '../stores/todoStore';
import { useEffect } from 'react';

export const TodoList: React.FC = () => {
  const { todos, isLoading, error, fetchTodos, clearError } = useTodoStore();

  useEffect(() => {
    fetchTodos();
  }, [fetchTodos]);

  // 로딩 상태
  if (isLoading) {
    return (
      <div className="loading-container">
        <div className="loading-spinner">🌱</div>
        <p>할일을 불러오는 중...</p>
      </div>
    );
  }

  // 에러 상태
  if (error) {
    return (
      <div className="error-container">
        <div className="error-icon">😞</div>
        <h3>앗! 문제가 발생했어요</h3>
        <p>{error}</p>
        <div className="error-actions">
          <button onClick={() => { clearError(); fetchTodos(); }}>
            다시 시도
          </button>
          <button onClick={clearError}>
            확인
          </button>
        </div>
      </div>
    );
  }

  // 정상 상태
  return (
    <div className="todo-list">
      {todos.length === 0 ? (
        <div className="empty-state">
          <div className="empty-icon">📝</div>
          <p>아직 할일이 없어요. 첫 번째 할일을 추가해보세요!</p>
        </div>
      ) : (
        <ul>
          {todos.map(todo => (
            <TodoItem key={todo.id} todo={todo} />
          ))}
        </ul>
      )}
    </div>
  );
};
```

## 📝 기본 로깅

### 백엔드 로깅 설정

```yaml
# src/main/resources/application.yml
logging:
  level:
    com.study.todolist: INFO
    org.springframework.web: WARN
    org.hibernate.SQL: DEBUG
  pattern:
    console: "%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n"
```

### 프론트엔드 간단 로깅

```typescript
// src/utils/logger.ts
export const logger = {
  info: (message: string, data?: any) => {
    console.log(`[INFO] ${message}`, data || '');
  },

  warn: (message: string, data?: any) => {
    console.warn(`[WARN] ${message}`, data || '');
  },

  error: (message: string, error?: any) => {
    console.error(`[ERROR] ${message}`, error || '');

    // MVP에서는 간단히 로컬스토리지에 에러 로그 저장
    if (typeof window !== 'undefined') {
      const errorLog = {
        message,
        error: error?.message || error,
        timestamp: new Date().toISOString(),
        url: window.location.href
      };

      try {
        const logs = JSON.parse(localStorage.getItem('error-logs') || '[]');
        logs.push(errorLog);
        // 최대 50개까지만 저장
        if (logs.length > 50) logs.shift();
        localStorage.setItem('error-logs', JSON.stringify(logs));
      } catch (e) {
        console.warn('Failed to save error log to localStorage');
      }
    }
  }
};
```

## 🎨 에러 UI 스타일

```css
/* src/styles/error.css */

/* 에러 토스트 */
.error-toast {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 1000;
  animation: slideIn 0.3s ease-out;
}

.error-content {
  background: #fee;
  border: 1px solid #fcc;
  border-radius: 8px;
  padding: 12px 16px;
  display: flex;
  align-items: center;
  gap: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.error-icon {
  font-size: 18px;
}

.error-message {
  color: #c53030;
  font-weight: 500;
}

.error-close {
  background: none;
  border: none;
  font-size: 18px;
  color: #999;
  cursor: pointer;
  padding: 0;
  margin-left: 8px;
}

/* 에러 컨테이너 */
.error-container {
  text-align: center;
  padding: 40px 20px;
  color: #666;
}

.error-icon {
  font-size: 48px;
  margin-bottom: 16px;
}

.error-actions {
  display: flex;
  gap: 12px;
  justify-content: center;
  margin-top: 20px;
}

.error-actions button {
  padding: 8px 16px;
  border: 1px solid #ddd;
  border-radius: 4px;
  background: white;
  cursor: pointer;
}

.error-actions button:first-child {
  background: #4CAF50;
  color: white;
  border-color: #4CAF50;
}

/* 로딩 상태 */
.loading-container {
  text-align: center;
  padding: 40px 20px;
  color: #666;
}

.loading-spinner {
  font-size: 32px;
  animation: spin 2s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

@keyframes slideIn {
  from { transform: translateX(100%); opacity: 0; }
  to { transform: translateX(0); opacity: 1; }
}
```

---

**MVP 에러 처리 원칙**:
- 사용자 친화적 메시지 우선
- 복잡한 재시도 로직 없이 간단한 "다시 시도" 버튼
- 기본적인 로깅으로 디버깅 지원
- 감성적인 메시지로 부드러운 사용자 경험 제공