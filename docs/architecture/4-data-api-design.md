# 4. Data & API Design

## 4.1. Data Models

### Todo
**Purpose:** 사용자가 완료해야 할 단일 작업을 나타냅니다. 이 애플리케이션의 핵심 엔티티(Entity)입니다.
**Key Attributes:**
- `id`: `Long` - 고유 식별자 (Primary Key)
- `content`: `String` - 할 일의 내용
- `completed`: `Boolean` - 할 일의 완료 여부
- `createdAt`: `LocalDateTime` - 생성 일시
**TypeScript Interface**
```typescript
interface Todo {
  id: number;
  content: string;
  completed: boolean;
  createdAt: string; // ISO 8601 format
}
```
**Relationships**
- `BasilPot`과 간접적인 관계를 가집니다. (할 일이 완료될 때마다 화분의 성장에 영향을 줍니다.)

### BasilPot
**Purpose:** 사용자의 성장을 나타내며, 할 일 완료에 대한 시각적 보상 역할을 합니다. DDD 관점에서 보면, 사용자의 성취 상태를 나타내는 Aggregate Root가 될 수 있습니다.
**Key Attributes:**
- `id`: `Long` - 고유 식별자 (Primary Key)
- `level`: `Integer` - 바질 화분의 현재 성장 레벨. 1부터 시작합니다.
- `experience`: `Integer` - 다음 레벨까지 필요한 경험치. 할 일을 완료할 때마다 증가합니다.
- `userId`: `Long` - 이 화분의 소유자 ID.
**TypeScript Interface**
```typescript
interface BasilPot {
  id: number;
  level: number;
  experience: number;
  userId: number;
}
```
**Relationships**
-   User와 1:1 관계를 가집니다.
-   `Todo`가 완료될 때마다 `experience`가 업데이트됩니다. (도메인 이벤트)

## 4.2. Database Schema
```sql
-- 사용자(Users) 테이블
CREATE TABLE `users` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(255) NOT NULL, -- 이메일을 ID로 사용할 가능성을 위해 255자로 유지
  `password` VARCHAR(255) NOT NULL, -- 비밀번호는 해시된 결과를 저장
  `nickname` VARCHAR(30) NOT NULL,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 할 일(Todo) 테이블
CREATE TABLE `todos` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `content` VARCHAR(255) NOT NULL,
  `completed` BOOLEAN NOT NULL DEFAULT FALSE,
  `created_at` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `user_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_todos_to_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 바질 화분(BasilPot) 테이블
CREATE TABLE `basil_pot` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `level` INT NOT NULL DEFAULT 1,
  `experience` INT NOT NULL DEFAULT 0,
  `user_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`),
  CONSTRAINT `fk_basil_pot_to_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

## 4.3. API Specification
```yaml
openapi: 3.0.0
info:
  title: 감성적인 할일 목록 API
  version: v0.1.0
  description: 감성적인 할일 목록 MVP를 위한 백엔드 API 명세서
servers:
  - url: http://localhost:8080/api
    description: Local development server
paths:
  /todos:
    get:
      summary: 모든 할 일 목록 조회
      responses:
        '200':
          description: 성공
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Todo'
    post:
      summary: 새로운 할 일 추가
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/NewTodo'
      responses:
        '201':
          description: 생성됨
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Todo'
  /todos/{id}/complete:
    patch:
      summary: 특정 할 일 완료 처리
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: integer
            format: int64
      responses:
        '200':
          description: 성공
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Todo'
  /basil-pot:
    get:
      summary: 바질 화분 상태 조회
      responses:
        '200':
          description: 성공
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/BasilPot'
components:
  schemas:
    Todo:
      type: object
      properties:
        id:
          type: integer
          format: int64
        content:
          type: string
        completed:
          type: boolean
        createdAt:
          type: string
          format: date-time
    NewTodo:
      type: object
      properties:
        content:
          type: string
    BasilPot:
      type: object
      properties:
        id:
          type: integer
          format: int64
        level:
          type: integer
        experience:
          type: integer
        userId:
          type: integer
          format: int64
```

---
