# 5. Backend Architecture

## 5.1. Service Architecture
### Service (Controller) Organization
```text
src/main/java/com/study/todolist/
├── domain/
├── application/
└── adapter/
    ├── in/
    │   └── web/
    │       ├── dto/
    │       └── TodoController.java
    └── out/
        └── persistence/
```
### Controller Template
```java
@RestController
@RequestMapping("/api/todos")
@RequiredArgsConstructor
public class TodoController {
    private final TodoUseCase todoUseCase;
    // ...
}
```

## 5.2. Database Architecture
### Data Access Layer
**Output Port**
```java
public interface TodoPort {
    Todo save(Todo todo);
    Optional<Todo> findById(Long id);
    List<Todo> findAllByUserId(Long userId);
}
```
**Persistence Adapter**
```java
@Repository
@RequiredArgsConstructor
public class TodoPersistenceAdapter implements TodoPort {
    private final TodoRepository todoRepository;
    // ...
}
```
**Spring Data JPA Repository**
```java
interface TodoRepository extends JpaRepository<Todo, Long> {
    List<Todo> findAllByUserId(Long userId);
}
```

## 5.3. Auth Architecture
### Auth Flow
```mermaid
sequenceDiagram
    participant User
    participant Frontend as Next.js App
    participant Backend as Spring Boot API
    participant DB as MySQL Database
    User->>Frontend: 로그인
    Frontend->>Backend: POST /api/auth/login
    Backend->>Backend: JWT 생성
    Backend-->>Frontend: 200 OK (Access Token, Refresh Token)
    Frontend->>Backend: GET /api/todos (with Token)
    Backend->>Backend: JWT 유효성 검증
    Backend-->>Frontend: 200 OK (데이터)
```
### Auth Middleware/Filter
```java
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {
    // ...
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf().disable()
            .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            .and()
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/auth/**").permitAll()
                .anyRequest().authenticated()
            )
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }
}
```

---
