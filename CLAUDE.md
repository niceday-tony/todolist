# CLAUDE.md - TodoList 프로젝트 AI 협업 가이드

## 프로젝트 컨텍스트

이 프로젝트는 5명의 개발자가 Claude Code를 활용하여 동시에 작업하면서도 코드 충돌과 일관성 문제를 최소화하는 협업 방법론을 개발하는 실험적 스터디입니다. 백엔드 개발자 4명과 프론트엔드 개발자 1명이
참여하며, 모든 팀원이 풀스택 영역에서 AI와 함께 작업합니다.

현재 프로젝트는 초기 단계로 backend와 frontend 폴더만 생성된 상태입니다. 이 가이드는 Claude가 각 개발자의 의도를 정확히 이해하고 충돌 없이 코드를 생성할 수 있도록 명확한 지침을 제공합니다.

## 프로젝트 초기화 절차

### Spring Boot 백엔드 설정

backend 폴더로 이동한 후 Spring Initializr를 사용하여 프로젝트를 초기화합니다. 필요한 의존성은 Spring Web, Spring Data JPA, MySQL Driver, Validation,
Lombok입니다.

```bash
cd backend
curl https://start.spring.io/starter.zip \
  -d dependencies=web,data-jpa,mysql,validation,lombok \
  -d type=gradle-project \
  -d language=java \
  -d bootVersion=3.2.0 \
  -d javaVersion=17 \
  -d groupId=com.study \
  -d artifactId=todolist \
  -d name=todolist \
  -d packageName=com.study.todolist \
  -d packaging=jar \
  -o temp.zip && unzip temp.zip && rm temp.zip
```

application.yml 파일을 생성하여 데이터베이스 연결을 설정합니다:

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/todolist?useSSL=false&serverTimezone=Asia/Seoul&characterEncoding=UTF-8
    username: root
    password: root
    driver-class-name: com.mysql.cj.jdbc.Driver

  jpa:
    hibernate:
      ddl-auto: update
    properties:
      hibernate:
        format_sql: true
        show_sql: true
        dialect: org.hibernate.dialect.MySQL8Dialect
    open-in-view: false

server:
  port: 8080
  servlet:
    context-path: /api
```

### Vue 3 프론트엔드 설정

frontend 폴더에서 Vue 3 프로젝트를 생성합니다. TypeScript, Vue Router, Pinia를 포함하여 설정합니다.

```bash
cd frontend
npm create vue@latest . -- --typescript --router --pinia --vitest
npm install axios
npm install -D @tailwindcss/forms tailwindcss postcss autoprefixer
npx tailwindcss init -p
```

tailwind.config.js 설정:

```javascript
export default {
    content: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
    theme: {
        extend: {},
    },
    plugins: [require('@tailwindcss/forms')],
}
```

### Docker 환경 구성

프로젝트 루트에 docker-compose.yml 파일을 생성합니다:

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: todolist-mysql
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: todolist
      MYSQL_CHARACTER_SET: utf8mb4
      MYSQL_COLLATION: utf8mb4_unicode_ci
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql
    networks:
      - todolist-network

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: todolist-backend
    ports:
      - "8080:8080"
    depends_on:
      - mysql
    environment:
      SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/todolist?useSSL=false&serverTimezone=Asia/Seoul
      SPRING_DATASOURCE_USERNAME: root
      SPRING_DATASOURCE_PASSWORD: root
    networks:
      - todolist-network

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    container_name: todolist-frontend
    ports:
      - "5173:5173"
    depends_on:
      - backend
    networks:
      - todolist-network

volumes:
  mysql-data:

networks:
  todolist-network:
    driver: bridge
```

## 코드 생성 규칙과 패턴

### Java/Spring Boot 코드 작성 원칙

모든 Java 클래스는 완전한 형태로 작성되어야 합니다. import 문을 포함한 전체 코드를 제공하며, 플레이스홀더나 주석으로 대체하지 않습니다.

Entity 클래스 예시:

```java
미정
```

Service 클래스 작성 시

```java
미정
```

Controller 작성 시 RESTful 원칙을 준수합니다:

```java
미정
```

### Vue 3/TypeScript 코드 작성 원칙

Vue 컴포넌트는 Composition API를 사용하여 작성합니다. TypeScript 타입을 명확히 정의하고, Props와 Emits를 타입 안전하게 구현합니다.

API 클라이언트 구성:

```typescript
미정
```

Pinia Store 구성:

```typescript
미정
```

## 협업 시나리오와 충돌 방지 전략

### 시나리오 1: 동일 파일 및 코드 수정

```java
미정
```

### 시나리오 2: Entity 수정

Entity 클래스 수정은 데이터베이스 스키마에 영향을 미치므로 반드시 팀 전체 합의 후 진행합니다. 수정 시 마이그레이션 스크립트를 함께 작성합니다.

## Git 브랜치 전략과 커밋 규칙

### 브랜치 전략

main 브랜치는 프로덕션 준비 상태를 유지합니다. develop 브랜치에서 개발을 진행하며, 각 기능은 feature 브랜치에서 작업합니다.

```bash
# feature 브랜치 생성 및 작업
git checkout develop
git pull origin develop
git checkout -b feature/todo-search

# 작업 완료 후 PR 생성
git add .
git commit -m "feat: add todo search functionality"
git push origin feature/todo-search
```

### 커밋 메시지 규칙

커밋 메시지는 다음 형식을 따릅니다:

- feat: 새로운 기능 추가
- fix: 버그 수정
- docs: 문서 수정
- style: 코드 포맷팅
- refactor: 코드 리팩토링
- test: 테스트 추가

## 테스트 작성 가이드

### Spring Boot 단위 테스트

```java
미정
```

### Vue 컴포넌트 테스트

```typescript
미정
```

## MCP 서버 설정과 활용

프로젝트 루트의 .mcp.json 파일을 통해 외부 도구와 연동합니다:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-github"
      ],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "task-master": {
      "command": "npx",
      "args": [
        "-y",
        "claude-task-master"
      ],
      "env": {
        "PROJECT_PATH": "${PWD}"
      }
    }
  }
}
```

## Claude 활용 베스트 프랙티스

미정

---

이 가이드는 프로젝트 진행에 따라 지속적으로 업데이트됩니다. 팀원 모두가 이 규칙을 준수하여 효율적이고 충돌 없는 협업을 달성하는 것이 목표입니다.