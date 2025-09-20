# 운영 준비성 가이드

## 개요

"감성적인 할일 목록" 애플리케이션의 운영 환경 준비성을 위한 종합 가이드입니다. 에러 처리, 모니터링, 로깅, 성능 관리 등 프로덕션 환경에서 안정적으로 서비스를 운영하기 위한 모든 요소를 다룹니다.

## 1. 에러 처리 전략 (Error Handling Strategy)

### 1.1 백엔드 에러 처리

#### 글로벌 예외 처리기
```java
// src/main/java/com/study/todolist/exception/GlobalExceptionHandler.java
@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ExceptionHandler(TodoNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleTodoNotFound(TodoNotFoundException ex) {
        log.warn("Todo not found: {}", ex.getMessage());
        ErrorResponse error = ErrorResponse.builder()
            .code("TODO_NOT_FOUND")
            .message("요청한 할일을 찾을 수 없습니다.")
            .details(Map.of("todoId", ex.getTodoId()))
            .timestamp(LocalDateTime.now())
            .build();
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    @ExceptionHandler(ValidationException.class)
    public ResponseEntity<ErrorResponse> handleValidation(ValidationException ex) {
        log.warn("Validation error: {}", ex.getMessage());
        ErrorResponse error = ErrorResponse.builder()
            .code("VALIDATION_ERROR")
            .message("입력 데이터가 올바르지 않습니다.")
            .details(ex.getFieldErrors())
            .timestamp(LocalDateTime.now())
            .build();
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGeneral(Exception ex) {
        log.error("Unexpected error occurred", ex);
        ErrorResponse error = ErrorResponse.builder()
            .code("INTERNAL_SERVER_ERROR")
            .message("서버 내부 오류가 발생했습니다.")
            .timestamp(LocalDateTime.now())
            .build();
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }
}
```

#### 커스텀 예외 클래스
```java
// src/main/java/com/study/todolist/exception/TodoNotFoundException.java
public class TodoNotFoundException extends RuntimeException {
    private final Long todoId;

    public TodoNotFoundException(Long todoId) {
        super("Todo not found with id: " + todoId);
        this.todoId = todoId;
    }

    public Long getTodoId() {
        return todoId;
    }
}

// src/main/java/com/study/todolist/exception/ValidationException.java
public class ValidationException extends RuntimeException {
    private final Map<String, String> fieldErrors;

    public ValidationException(Map<String, String> fieldErrors) {
        super("Validation failed");
        this.fieldErrors = fieldErrors;
    }

    public Map<String, String> getFieldErrors() {
        return fieldErrors;
    }
}
```

#### 표준 에러 응답 형식
```java
// src/main/java/com/study/todolist/dto/response/ErrorResponse.java
@Data
@Builder
public class ErrorResponse {
    private String code;           // 에러 코드
    private String message;        // 사용자 친화적 메시지
    private Map<String, Object> details; // 상세 정보
    private LocalDateTime timestamp;      // 발생 시간
}
```

### 1.2 프론트엔드 에러 처리

#### API 에러 처리 서비스
```typescript
// src/services/errorHandler.ts
export interface ApiError {
  code: string;
  message: string;
  details?: Record<string, any>;
  timestamp: string;
}

export class ErrorHandler {
  static handle(error: any): ApiError {
    // 네트워크 에러
    if (!error.response) {
      return {
        code: 'NETWORK_ERROR',
        message: '네트워크 연결을 확인해주세요.',
        timestamp: new Date().toISOString()
      };
    }

    // HTTP 상태 코드별 처리
    const { status, data } = error.response;

    switch (status) {
      case 400:
        return data || {
          code: 'BAD_REQUEST',
          message: '잘못된 요청입니다.',
          timestamp: new Date().toISOString()
        };
      case 404:
        return data || {
          code: 'NOT_FOUND',
          message: '요청한 리소스를 찾을 수 없습니다.',
          timestamp: new Date().toISOString()
        };
      case 500:
        return data || {
          code: 'INTERNAL_SERVER_ERROR',
          message: '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
          timestamp: new Date().toISOString()
        };
      default:
        return {
          code: 'UNKNOWN_ERROR',
          message: '알 수 없는 오류가 발생했습니다.',
          timestamp: new Date().toISOString()
        };
    }
  }

  static showUserFriendlyMessage(error: ApiError): void {
    // 토스트 메시지나 모달로 사용자에게 표시
    console.error('API Error:', error);
    // TODO: 실제 UI 알림 구현
  }
}
```

#### React 에러 바운더리
```typescript
// src/components/ErrorBoundary.tsx
interface Props {
  children: React.ReactNode;
}

interface State {
  hasError: boolean;
  error?: Error;
}

export class ErrorBoundary extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    console.error('React Error Boundary caught an error:', error, errorInfo);
    // 에러 리포팅 서비스로 전송 (Sentry 등)
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="error-fallback">
          <h2>앗! 문제가 발생했습니다</h2>
          <p>페이지를 새로고침하거나 잠시 후 다시 시도해주세요.</p>
          <button onClick={() => window.location.reload()}>
            새로고침
          </button>
        </div>
      );
    }

    return this.props.children;
  }
}
```

## 2. 로깅 전략 (Logging Strategy)

### 2.1 백엔드 로깅 설정

#### Logback 설정
```xml
<!-- src/main/resources/logback-spring.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <!-- 로컬 개발용 콘솔 출력 -->
    <springProfile name="local">
        <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
            <encoder>
                <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
            </encoder>
        </appender>
        <root level="DEBUG">
            <appender-ref ref="CONSOLE"/>
        </root>
    </springProfile>

    <!-- 프로덕션용 파일 출력 -->
    <springProfile name="prod">
        <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
            <file>logs/todolist.log</file>
            <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
                <fileNamePattern>logs/todolist.%d{yyyy-MM-dd}.%i.gz</fileNamePattern>
                <maxFileSize>100MB</maxFileSize>
                <maxHistory>30</maxHistory>
                <totalSizeCap>3GB</totalSizeCap>
            </rollingPolicy>
            <encoder class="net.logstash.logback.encoder.LoggingEventCompositeJsonEncoder">
                <providers>
                    <timestamp/>
                    <logLevel/>
                    <loggerName/>
                    <message/>
                    <mdc/>
                    <stackTrace/>
                </providers>
            </encoder>
        </appender>
        <root level="INFO">
            <appender-ref ref="FILE"/>
        </root>
    </springProfile>

    <!-- 특정 패키지별 로그 레벨 설정 -->
    <logger name="com.study.todolist" level="DEBUG"/>
    <logger name="org.springframework.web" level="DEBUG"/>
    <logger name="org.hibernate.SQL" level="DEBUG"/>
    <logger name="org.hibernate.type.descriptor.sql.BasicBinder" level="TRACE"/>
</configuration>
```

#### 구조화된 로깅
```java
// src/main/java/com/study/todolist/service/TodoService.java
@Service
@Slf4j
public class TodoService {

    public TodoResponse createTodo(TodoCreateRequest request) {
        // 구조화된 로깅 with MDC
        MDC.put("operation", "createTodo");
        MDC.put("userId", getCurrentUserId());

        try {
            log.info("Creating new todo: title={}", request.getTitle());

            Todo todo = Todo.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .priority(request.getPriority())
                .dueDate(request.getDueDate())
                .build();

            Todo savedTodo = todoRepository.save(todo);

            log.info("Todo created successfully: todoId={}", savedTodo.getId());

            return TodoMapper.toResponse(savedTodo);

        } catch (Exception e) {
            log.error("Failed to create todo: title={}, error={}",
                request.getTitle(), e.getMessage(), e);
            throw new TodoCreationException("할일 생성에 실패했습니다.", e);
        } finally {
            MDC.clear();
        }
    }
}
```

### 2.2 프론트엔드 로깅

#### 클라이언트 로거 설정
```typescript
// src/utils/logger.ts
enum LogLevel {
  DEBUG = 0,
  INFO = 1,
  WARN = 2,
  ERROR = 3
}

interface LogEntry {
  level: LogLevel;
  message: string;
  data?: any;
  timestamp: string;
  userAgent: string;
  url: string;
}

class Logger {
  private minLevel: LogLevel = LogLevel.INFO;

  constructor() {
    // 개발 환경에서는 DEBUG 레벨
    if (process.env.NODE_ENV === 'development') {
      this.minLevel = LogLevel.DEBUG;
    }
  }

  private log(level: LogLevel, message: string, data?: any) {
    if (level < this.minLevel) return;

    const entry: LogEntry = {
      level,
      message,
      data,
      timestamp: new Date().toISOString(),
      userAgent: navigator.userAgent,
      url: window.location.href
    };

    // 콘솔 출력
    const logMethod = this.getConsoleMethod(level);
    logMethod(`[${LogLevel[level]}] ${message}`, data || '');

    // 프로덕션에서는 로그 수집 서비스로 전송
    if (process.env.NODE_ENV === 'production' && level >= LogLevel.WARN) {
      this.sendToLogService(entry);
    }
  }

  private getConsoleMethod(level: LogLevel) {
    switch (level) {
      case LogLevel.DEBUG: return console.debug;
      case LogLevel.INFO: return console.info;
      case LogLevel.WARN: return console.warn;
      case LogLevel.ERROR: return console.error;
      default: return console.log;
    }
  }

  private async sendToLogService(entry: LogEntry) {
    try {
      // 실제 로그 수집 서비스 (Sentry, LogRocket 등)로 전송
      await fetch('/api/logs', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(entry)
      });
    } catch (error) {
      console.error('Failed to send log to service:', error);
    }
  }

  debug(message: string, data?: any) { this.log(LogLevel.DEBUG, message, data); }
  info(message: string, data?: any) { this.log(LogLevel.INFO, message, data); }
  warn(message: string, data?: any) { this.log(LogLevel.WARN, message, data); }
  error(message: string, data?: any) { this.log(LogLevel.ERROR, message, data); }
}

export const logger = new Logger();
```

## 3. 모니터링 및 관찰가능성 (Monitoring & Observability)

### 3.1 애플리케이션 메트릭

#### Spring Boot Actuator 설정
```yaml
# src/main/resources/application.yml
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
      base-path: /actuator
  endpoint:
    health:
      show-details: always
    metrics:
      enabled: true
  metrics:
    export:
      prometheus:
        enabled: true
    distribution:
      percentiles-histogram:
        http.server.requests: true
```

#### 커스텀 메트릭
```java
// src/main/java/com/study/todolist/config/MetricsConfig.java
@Configuration
public class MetricsConfig {

    @Bean
    public Counter todoCreationCounter(MeterRegistry meterRegistry) {
        return Counter.builder("todo.created.total")
            .description("Total number of todos created")
            .register(meterRegistry);
    }

    @Bean
    public Timer todoOperationTimer(MeterRegistry meterRegistry) {
        return Timer.builder("todo.operation.duration")
            .description("Time taken for todo operations")
            .register(meterRegistry);
    }

    @Bean
    public Gauge activeTodosGauge(MeterRegistry meterRegistry, TodoRepository todoRepository) {
        return Gauge.builder("todo.active.count")
            .description("Number of active todos")
            .register(meterRegistry, todoRepository, repo -> repo.countByCompletedFalse());
    }
}
```

### 3.2 헬스 체크

#### 커스텀 헬스 인디케이터
```java
// src/main/java/com/study/todolist/health/DatabaseHealthIndicator.java
@Component
public class DatabaseHealthIndicator implements HealthIndicator {

    private final TodoRepository todoRepository;

    public DatabaseHealthIndicator(TodoRepository todoRepository) {
        this.todoRepository = todoRepository;
    }

    @Override
    public Health health() {
        try {
            long count = todoRepository.count();
            return Health.up()
                .withDetail("database", "MySQL")
                .withDetail("totalTodos", count)
                .withDetail("status", "Connected")
                .build();
        } catch (Exception e) {
            return Health.down()
                .withDetail("database", "MySQL")
                .withDetail("error", e.getMessage())
                .withDetail("status", "Disconnected")
                .build();
        }
    }
}
```

### 3.3 프론트엔드 성능 모니터링

#### Web Vitals 측정
```typescript
// src/utils/webVitals.ts
import { getCLS, getFID, getFCP, getLCP, getTTFB } from 'web-vitals';

interface VitalMetric {
  name: string;
  value: number;
  rating: 'good' | 'needs-improvement' | 'poor';
  timestamp: number;
}

class WebVitalsMonitor {
  private metrics: VitalMetric[] = [];

  init() {
    getCLS(this.onVital.bind(this));
    getFID(this.onVital.bind(this));
    getFCP(this.onVital.bind(this));
    getLCP(this.onVital.bind(this));
    getTTFB(this.onVital.bind(this));
  }

  private onVital(metric: any) {
    const vitalMetric: VitalMetric = {
      name: metric.name,
      value: metric.value,
      rating: metric.rating,
      timestamp: Date.now()
    };

    this.metrics.push(vitalMetric);

    // 성능 데이터를 서버로 전송
    this.sendMetric(vitalMetric);
  }

  private async sendMetric(metric: VitalMetric) {
    try {
      await fetch('/api/metrics/web-vitals', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(metric)
      });
    } catch (error) {
      console.error('Failed to send web vital metric:', error);
    }
  }

  getMetrics(): VitalMetric[] {
    return [...this.metrics];
  }
}

export const webVitalsMonitor = new WebVitalsMonitor();
```

## 4. 복원력 및 장애 복구 (Resilience & Recovery)

### 4.1 Circuit Breaker 패턴

```java
// src/main/java/com/study/todolist/service/ExternalApiService.java
@Service
@Slf4j
public class ExternalApiService {

    private final CircuitBreaker circuitBreaker;
    private final RestTemplate restTemplate;

    public ExternalApiService() {
        this.circuitBreaker = CircuitBreaker.ofDefaults("externalApi");
        this.circuitBreaker.getEventPublisher()
            .onStateTransition(event ->
                log.info("Circuit breaker state transition: {} -> {}",
                    event.getStateTransition().getFromState(),
                    event.getStateTransition().getToState()));
        this.restTemplate = new RestTemplate();
    }

    public Optional<String> getMotivationalMessage() {
        Supplier<String> decoratedSupplier = CircuitBreaker
            .decorateSupplier(circuitBreaker, () -> {
                // 외부 API 호출
                return restTemplate.getForObject("/api/messages/random", String.class);
            });

        try {
            return Optional.of(decoratedSupplier.get());
        } catch (Exception e) {
            log.warn("External API call failed, using fallback", e);
            return getFallbackMessage();
        }
    }

    private Optional<String> getFallbackMessage() {
        List<String> fallbackMessages = Arrays.asList(
            "오늘도 고생하셨습니다! 🌿",
            "작은 성취도 큰 의미가 있어요 ✨",
            "한 걸음씩 나아가고 있어요 🌱"
        );

        Random random = new Random();
        return Optional.of(fallbackMessages.get(random.nextInt(fallbackMessages.size())));
    }
}
```

### 4.2 재시도 메커니즘

```java
// src/main/java/com/study/todolist/config/RetryConfig.java
@Configuration
@EnableRetry
public class RetryConfig {

    @Bean
    public RetryTemplate retryTemplate() {
        RetryTemplate retryTemplate = new RetryTemplate();

        FixedBackOffPolicy backOffPolicy = new FixedBackOffPolicy();
        backOffPolicy.setBackOffPeriod(1000L); // 1초 대기

        SimpleRetryPolicy retryPolicy = new SimpleRetryPolicy();
        retryPolicy.setMaxAttempts(3);

        retryTemplate.setBackOffPolicy(backOffPolicy);
        retryTemplate.setRetryPolicy(retryPolicy);

        return retryTemplate;
    }
}

// 사용 예시
@Service
public class TodoService {

    @Retryable(value = {DataAccessException.class}, maxAttempts = 3)
    public TodoResponse updateTodo(Long id, TodoUpdateRequest request) {
        // 데이터베이스 업데이트 로직
        return todoRepository.save(todo);
    }

    @Recover
    public TodoResponse recover(DataAccessException ex, Long id, TodoUpdateRequest request) {
        log.error("All retry attempts failed for updateTodo: id={}", id, ex);
        throw new TodoUpdateException("할일 업데이트에 실패했습니다. 잠시 후 다시 시도해주세요.");
    }
}
```

## 5. 성능 모니터링 및 최적화

### 5.1 데이터베이스 성능 모니터링

```java
// src/main/java/com/study/todolist/config/DatabaseMonitoringConfig.java
@Configuration
public class DatabaseMonitoringConfig {

    @Bean
    public ProxyDataSource dataSource(@Qualifier("actualDataSource") DataSource actualDataSource) {
        return ProxyDataSourceBuilder
            .create(actualDataSource)
            .name("TodoListDS")
            .logQueryBySlf4j(SLF4JLogLevel.INFO)
            .logSlowQueryBySlf4j(10, TimeUnit.SECONDS, SLF4JLogLevel.WARN)
            .countQuery(true)
            .multiline()
            .build();
    }
}
```

### 5.2 캐싱 전략

```java
// src/main/java/com/study/todolist/config/CacheConfig.java
@Configuration
@EnableCaching
public class CacheConfig {

    @Bean
    public CacheManager cacheManager() {
        SimpleCacheManager cacheManager = new SimpleCacheManager();
        cacheManager.setCaches(Arrays.asList(
            new ConcurrentMapCache("todos"),
            new ConcurrentMapCache("motivationalMessages")
        ));
        return cacheManager;
    }
}

// 서비스에서 캐시 사용
@Service
public class TodoService {

    @Cacheable(value = "todos", key = "#userId")
    public List<TodoResponse> getTodosByUser(Long userId) {
        return todoRepository.findByUserIdOrderByCreatedAtDesc(userId)
            .stream()
            .map(TodoMapper::toResponse)
            .collect(Collectors.toList());
    }

    @CacheEvict(value = "todos", key = "#userId")
    public TodoResponse createTodo(Long userId, TodoCreateRequest request) {
        // 할일 생성 로직
        return savedTodo;
    }
}
```

## 6. 알림 및 경고 시스템

### 6.1 알림 규칙 정의

```yaml
# monitoring/alerts.yml
alerts:
  - name: high_error_rate
    condition: error_rate > 5%
    duration: 2m
    severity: critical
    message: "에러율이 높습니다: {{ $value }}%"

  - name: slow_response_time
    condition: avg_response_time > 1s
    duration: 5m
    severity: warning
    message: "응답 시간이 느립니다: {{ $value }}ms"

  - name: database_connection_failure
    condition: db_health == false
    duration: 30s
    severity: critical
    message: "데이터베이스 연결에 실패했습니다"

  - name: memory_usage_high
    condition: memory_usage > 80%
    duration: 5m
    severity: warning
    message: "메모리 사용량이 높습니다: {{ $value }}%"
```

### 6.2 장애 대응 플레이북

```markdown
# 장애 대응 플레이북

## 심각도별 대응 절차

### Critical (심각)
1. 즉시 대응팀에 알림
2. 장애 원인 파악 및 임시 조치
3. 서비스 복구 후 근본 원인 분석
4. 사후 보고서 작성

### Warning (경고)
1. 모니터링 지속 관찰
2. 필요시 예방적 조치
3. 업무시간 내 해결

## 일반적인 장애 시나리오

### 1. 데이터베이스 연결 실패
- 확인사항: MySQL 컨테이너 상태, 네트워크 연결
- 대응방법: 컨테이너 재시작, 연결 풀 재설정

### 2. 높은 응답 시간
- 확인사항: CPU/메모리 사용량, 느린 쿼리
- 대응방법: 캐시 적용, 쿼리 최적화

### 3. 메모리 부족
- 확인사항: 힙 덤프 분석, 메모리 누수
- 대응방법: 애플리케이션 재시작, JVM 튜닝
```

---

*이 운영 준비성 가이드는 프로젝트 요구사항 변화에 따라 지속적으로 업데이트됩니다.*