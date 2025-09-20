# 기술 스택 명세서

## 개요

"감성적인 할일 목록" 프로젝트의 전체 기술 스택을 정의합니다. 로컬 개발 환경에서 MVP를 구축하기 위한 최적화된 기술 선택을 포함합니다.

## 아키텍처 개요

```
Frontend (Next.js) ←→ Backend (Spring Boot) ←→ Database (MySQL)
        ↓                      ↓                      ↓
   localhost:3000      localhost:8080         localhost:3306
```

## 백엔드 기술 스택

### 1. Core Framework
- **Java**: 17 LTS
- **Spring Boot**: 3.2.x
- **Spring Web**: REST API 구현
- **Spring Data JPA**: 데이터 액세스 레이어
- **Spring Security**: 인증/인가 (향후 확장용)

### 2. 데이터베이스
- **MySQL**: 8.0
- **Docker**: MySQL 컨테이너 실행
- **H2 Database**: 테스트용 인메모리 DB

### 3. 빌드 도구
- **Maven**: 3.8.x
- **Maven Wrapper**: 버전 일관성 보장

### 4. 개발 도구
- **Spring Boot DevTools**: 핫 리로드
- **Lombok**: 보일러플레이트 코드 감소
- **MapStruct**: DTO ↔ Entity 매핑
- **Validation**: Bean Validation (javax.validation)

### 5. 테스팅
- **JUnit 5**: 단위 테스트
- **Mockito**: 모킹 프레임워크
- **TestContainers**: 통합 테스트용 Docker 컨테이너
- **Spring Boot Test**: 통합 테스트

### 6. 로깅 & 모니터링
- **SLF4J + Logback**: 로깅
- **Spring Actuator**: 헬스체크 및 메트릭

## 프론트엔드 기술 스택

### 1. Core Framework
- **Node.js**: 18.x LTS
- **Next.js**: 14.x (App Router)
- **React**: 18.x
- **TypeScript**: 5.x

### 2. 상태 관리
- **React Query (TanStack Query)**: 서버 상태 관리
- **Zustand**: 클라이언트 상태 관리
- **React Hook Form**: 폼 상태 관리

### 3. 스타일링
- **Tailwind CSS**: 유틸리티 기반 CSS 프레임워크
- **CSS Modules**: 컴포넌트별 스타일 격리
- **Headless UI**: 접근성 고려 컴포넌트

### 4. HTTP 클라이언트
- **Axios**: HTTP 요청 라이브러리
- **React Query**: 캐싱 및 동기화

### 5. 개발 도구
- **ESLint**: 코드 린팅
- **Prettier**: 코드 포맷팅
- **Husky**: Git 훅 관리
- **lint-staged**: 스테이징된 파일 린팅

### 6. 테스팅
- **Jest**: 테스트 프레임워크
- **React Testing Library**: 컴포넌트 테스트
- **MSW (Mock Service Worker)**: API 모킹

## 데이터베이스 설계

### 1. MySQL 설정
```yaml
# docker-compose.yml
version: '3.8'
services:
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: todolist
      MYSQL_USER: todouser
      MYSQL_PASSWORD: todopass
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql

volumes:
  mysql_data:
```

### 2. 주요 테이블 구조

#### todos 테이블
```sql
CREATE TABLE todos (
    todo_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    completed BOOLEAN DEFAULT FALSE,
    priority ENUM('LOW', 'MEDIUM', 'HIGH') DEFAULT 'MEDIUM',
    due_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

#### users 테이블 (향후 확장용)
```sql
CREATE TABLE users (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

## 개발 환경 설정

### 1. 백엔드 환경
```properties
# application-local.properties
server.port=8080
spring.datasource.url=jdbc:mysql://localhost:3306/todolist
spring.datasource.username=todouser
spring.datasource.password=todopass
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true

logging.level.com.todolist=DEBUG
```

### 2. 프론트엔드 환경
```bash
# .env.local
NEXT_PUBLIC_API_BASE_URL=http://localhost:8080/api
NEXT_PUBLIC_APP_ENV=development
```

### 3. 필수 도구 버전
- **Java**: 17+
- **Node.js**: 18.x LTS
- **Docker**: 20.x+
- **Maven**: 3.8.x
- **npm**: 9.x+

## API 설계 패턴

### 1. REST API 엔드포인트
```
Base URL: http://localhost:8080/api

GET    /todos              # 할일 목록 조회
POST   /todos              # 할일 생성
GET    /todos/{id}         # 특정 할일 조회
PUT    /todos/{id}         # 할일 수정
DELETE /todos/{id}         # 할일 삭제
PATCH  /todos/{id}/toggle  # 완료 상태 토글
```

### 2. 응답 형식
```json
{
  "status": "success",
  "data": {
    "todoId": 1,
    "title": "프로젝트 설계",
    "description": "아키텍처 문서 작성",
    "completed": false,
    "priority": "HIGH",
    "dueDate": "2024-09-25",
    "createdAt": "2024-09-20T10:00:00Z",
    "updatedAt": "2024-09-20T10:00:00Z"
  },
  "message": "할일이 성공적으로 생성되었습니다."
}
```

### 3. 에러 응답 형식
```json
{
  "status": "error",
  "error": {
    "code": "TODO_NOT_FOUND",
    "message": "요청한 할일을 찾을 수 없습니다.",
    "details": {
      "todoId": 999
    }
  },
  "timestamp": "2024-09-20T10:00:00Z"
}
```

## 패키지 관리

### 1. 백엔드 의존성 (pom.xml)
```xml
<dependencies>
    <!-- Spring Boot Starters -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-validation</artifactId>
    </dependency>

    <!-- Database -->
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <scope>runtime</scope>
    </dependency>

    <!-- Development Tools -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-devtools</artifactId>
        <scope>runtime</scope>
        <optional>true</optional>
    </dependency>
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <optional>true</optional>
    </dependency>
</dependencies>
```

### 2. 프론트엔드 의존성 (package.json)
```json
{
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.0.0",
    "react-dom": "^18.0.0",
    "typescript": "^5.0.0",
    "@tanstack/react-query": "^5.0.0",
    "zustand": "^4.0.0",
    "react-hook-form": "^7.0.0",
    "axios": "^1.0.0",
    "tailwindcss": "^3.0.0"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "eslint": "^8.0.0",
    "eslint-config-next": "^14.0.0",
    "prettier": "^3.0.0",
    "jest": "^29.0.0",
    "@testing-library/react": "^14.0.0",
    "@testing-library/jest-dom": "^6.0.0"
  }
}
```

## 보안 고려사항

### 1. 기본 보안 설정
- **CORS**: 프론트엔드 도메인만 허용
- **Input Validation**: Bean Validation 사용
- **SQL Injection**: JPA/Hibernate로 방지
- **XSS**: React의 기본 이스케이핑 활용

### 2. 향후 확장 계획
- **JWT**: 사용자 인증 토큰
- **OAuth2**: 소셜 로그인
- **HTTPS**: SSL/TLS 인증서
- **Rate Limiting**: API 호출 제한

## 성능 최적화

### 1. 백엔드 최적화
- **Connection Pooling**: HikariCP (Spring Boot 기본)
- **JPA 최적화**: N+1 쿼리 방지, 적절한 페치 전략
- **캐싱**: Spring Cache (향후 Redis 도입 검토)

### 2. 프론트엔드 최적화
- **코드 스플리팅**: Next.js 자동 코드 분할
- **이미지 최적화**: Next.js Image 컴포넌트
- **번들 최적화**: Tree shaking, 불필요한 의존성 제거
- **React Query**: 서버 상태 캐싱

## 배포 전략 (향후)

### 1. 컨테이너화
```dockerfile
# Dockerfile.backend
FROM openjdk:17-jre-slim
COPY target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]

# Dockerfile.frontend
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build
EXPOSE 3000
CMD ["npm", "start"]
```

### 2. Docker Compose (전체 스택)
```yaml
version: '3.8'
services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    depends_on:
      - backend

  backend:
    build: ./backend
    ports:
      - "8080:8080"
    depends_on:
      - mysql

  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: todolist
    ports:
      - "3306:3306"
```

---

*이 기술 스택은 프로젝트 요구사항 변화에 따라 업데이트될 수 있습니다.*