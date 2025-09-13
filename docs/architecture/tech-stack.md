# Tech Stack Standards

## Overview

이 문서는 TodoList 프로젝트의 확정된 기술 스택을 정의합니다. **모든 개발은 이 스택을 따라야 합니다.**

## Backend Technology Stack

### Core Framework
- **Spring Boot**: 3.x
- **Java**: 17 (LTS)
- **Maven**: 3.8+ (의존성 관리)

### Database & Persistence
- **Database**: MySQL 8.0
- **ORM**: Spring Data JPA + Hibernate
- **Connection**: HikariCP (기본)
- **Migration**: JPA DDL (개발), Flyway (운영 준비)

### Web & API
- **REST API**: Spring Web MVC
- **JSON**: Jackson (Spring Boot 기본)
- **Validation**: Spring Boot Validation (JSR-303)
- **CORS**: Spring Security CORS 설정

### Development Tools
- **Build Tool**: Maven
- **Container**: Docker (MySQL)
- **IDE**: IntelliJ IDEA 권장

## Frontend Technology Stack

### Core Framework
- **Framework**: React 18.x
- **Language**: TypeScript 5.x
- **Build Tool**: Vite 4.x
- **Package Manager**: npm

### UI & Styling
- **Styling**: CSS Modules
- **Animation**: CSS Animations + React Spring 9.x
- **Component Library**: Headless UI 1.x (접근성)
- **Icons**: React Icons 또는 SVG

### State & Data
- **State Management**: React Built-in (useState, useContext)
- **HTTP Client**: Axios 1.x
- **Form Handling**: React Hook Form 7.x
- **Routing**: React Router 6.x

### Development & Testing
- **Testing**: React Testing Library 13.x
- **Linting**: ESLint + TypeScript rules
- **Dev Tools**: React DevTools, Vite HMR

## Infrastructure Stack

### Local Development
- **Database**: Docker MySQL 8.0
- **Container Orchestration**: docker-compose.yml
- **Ports**:
  - Backend: 8080
  - Frontend: 3000
  - MySQL: 3306

### Build & Deployment
- **Backend Build**: Maven package → JAR
- **Frontend Build**: Vite build → dist/
- **Static Serving**: Spring Boot (운영시)

## Version Requirements

```yaml
java: "17"
node: "18+"
npm: "9+"
docker: "20+"
mysql: "8.0"
```

## Key Dependencies

### Backend (pom.xml)
```xml
<dependencies>
    <!-- Web -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

    <!-- Data -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-j</artifactId>
        <scope>runtime</scope>
    </dependency>

    <!-- Validation -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-validation</artifactId>
    </dependency>
</dependencies>
```

### Frontend (package.json)
```json
{
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "axios": "^1.6.0",
    "react-router-dom": "^6.8.0",
    "react-hook-form": "^7.45.0",
    "@headlessui/react": "^1.7.0",
    "react-spring": "^9.7.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@vitejs/plugin-react": "^4.0.0",
    "typescript": "^5.0.0",
    "vite": "^4.4.0"
  }
}
```

## Architecture Constraints

### Backend Constraints
- **패키지 구조**: `com.study.todolist.*`
- **레이어 분리**: Controller → Service → Repository
- **트랜잭션**: `@Transactional` 필수 (식물 성장 로직)
- **API 규약**: REST + JSON, `/api/**` prefix

### Frontend Constraints
- **컴포넌트 구조**: 기능별 디렉토리 분리
- **스타일링**: CSS Modules 사용 필수
- **타입 안전성**: TypeScript strict mode
- **API 통신**: Axios interceptor 패턴

### Performance Requirements
- **백엔드 응답**: < 200ms
- **프론트엔드 렌더링**: 60fps 애니메이션
- **전체 피드백**: < 1초 (TODO 완료 → 식물 성장)

## Prohibited Technologies

다음 기술들은 **프로젝트 복잡성 증가**를 방지하기 위해 사용 금지:

- Redux, Zustand (상태관리 복잡성)
- Styled-components, Emotion (빌드 복잡성)
- GraphQL (API 복잡성)
- Microservices (아키텍처 복잡성)
- NoSQL (데이터 복잡성)

## Standards Compliance

모든 코드는 다음 표준을 준수해야 합니다:
- **coding-standards.md**: 코딩 스타일 및 패턴
- **source-tree.md**: 디렉토리 구조 및 파일 명명
- **architecture.md**: 전체 시스템 아키텍처