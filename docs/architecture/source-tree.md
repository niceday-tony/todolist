# Source Tree Structure

## Overview

TodoList 프로젝트의 디렉토리 구조와 파일 명명 규칙을 정의합니다. **모노레포** 구조를 채택합니다.

## Project Root Structure

```
todolist/
├── README.md                    # 프로젝트 개요 및 시작 가이드
├── docker-compose.yml           # MySQL 컨테이너 정의
├── .gitignore                   # Git 무시 파일 목록
├── .ai/                         # AI 개발 관련 파일
│   └── debug-log.md
├── .bmad-core/                  # BMad 에이전트 설정
│   ├── core-config.yaml
│   └── tasks/
├── docs/                        # 프로젝트 문서
│   ├── prd.md                   # 제품 요구사항 문서
│   ├── architecture.md          # 백엔드 아키텍처
│   ├── ui-architecture.md       # 프론트엔드 아키텍처
│   ├── DEVELOPMENT_SEQUENCE.md  # 개발 순서 가이드
│   ├── QUICK_START.md          # 빠른 시작 가이드
│   ├── architecture/           # 아키텍처 세부 문서
│   │   ├── coding-standards.md
│   │   ├── tech-stack.md
│   │   └── source-tree.md
│   ├── qa/                     # QA 결과 및 분석
│   │   ├── gates/
│   │   └── assessments/
│   └── stories/                # 개발 스토리
│       ├── 1.1.foundation-database-setup.md
│       ├── 1.2.basic-todo-management.md
│       ├── 1.3.plant-companion-system.md
│       ├── 1.4.growth-animation-feedback.md
│       └── 1.5.integrated-dashboard-ui.md
├── scripts/                    # 자동화 스크립트
│   ├── dev-start.sh           # 개발 환경 시작
│   ├── build-all.sh          # 전체 프로젝트 빌드
│   └── test-all.sh           # 전체 테스트 실행
├── backend/                   # Spring Boot 백엔드
└── frontend/                  # React 프론트엔드
```

## Backend Directory Structure

```
backend/
├── pom.xml                    # Maven 설정 및 의존성
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── study/
│   │   │           └── todolist/
│   │   │               ├── TodolistApplication.java  # Spring Boot 메인 클래스
│   │   │               ├── controller/               # REST Controllers
│   │   │               │   ├── TodoController.java
│   │   │               │   ├── PlantController.java
│   │   │               │   └── HealthController.java
│   │   │               ├── service/                  # 비즈니스 로직
│   │   │               │   ├── TodoService.java
│   │   │               │   ├── PlantService.java
│   │   │               │   └── PlantGrowthService.java
│   │   │               ├── repository/               # 데이터 접근
│   │   │               │   ├── TodoRepository.java
│   │   │               │   └── PlantRepository.java
│   │   │               ├── model/                    # JPA 엔티티
│   │   │               │   ├── Todo.java
│   │   │               │   └── Plant.java
│   │   │               ├── dto/                      # 요청/응답 DTO
│   │   │               │   ├── request/
│   │   │               │   │   ├── TodoCreateDto.java
│   │   │               │   │   └── TodoUpdateDto.java
│   │   │               │   └── response/
│   │   │               │       ├── TodoResponseDto.java
│   │   │               │       └── PlantResponseDto.java
│   │   │               ├── config/                   # Spring 설정
│   │   │               │   ├── CorsConfig.java
│   │   │               │   └── DatabaseConfig.java
│   │   │               └── exception/                # 예외 처리
│   │   │                   ├── GlobalExceptionHandler.java
│   │   │                   ├── EntityNotFoundException.java
│   │   │                   └── ErrorResponse.java
│   │   └── resources/
│   │       ├── application.yml         # 스프링 부트 설정
│   │       ├── application-dev.yml     # 개발 환경 설정
│   │       └── data.sql               # 초기 데이터 (선택적)
│   └── test/
│       └── java/
│           └── com/
│               └── study/
│                   └── todolist/
│                       ├── controller/              # 컨트롤러 테스트
│                       │   ├── TodoControllerTest.java
│                       │   └── PlantControllerTest.java
│                       ├── service/                 # 서비스 테스트
│                       │   ├── TodoServiceTest.java
│                       │   └── PlantServiceTest.java
│                       └── integration/             # 통합 테스트
│                           └── TodoIntegrationTest.java
├── target/                            # Maven 빌드 결과
└── logs/                              # 애플리케이션 로그
```

## Frontend Directory Structure

```
frontend/
├── package.json                # npm 의존성 및 스크립트
├── package-lock.json          # 정확한 의존성 버전 락
├── vite.config.ts             # Vite 빌드 설정
├── tsconfig.json              # TypeScript 설정
├── tsconfig.node.json         # Node.js TypeScript 설정
├── index.html                 # HTML 엔트리 포인트
├── .eslintrc.cjs             # ESLint 설정
├── public/                    # 정적 자산
│   ├── favicon.ico
│   ├── plant-images/          # 식물 이미지 (SVG)
│   │   ├── stage-1-seed.svg
│   │   ├── stage-2-sprout.svg
│   │   ├── stage-3-young.svg
│   │   ├── stage-4-grown.svg
│   │   └── stage-5-mature.svg
│   └── sounds/               # 효과음 (선택적)
│       ├── complete.mp3
│       └── growth.mp3
├── src/
│   ├── main.tsx              # React 앱 엔트리 포인트
│   ├── App.tsx               # 루트 애플리케이션 컴포넌트
│   ├── App.module.css        # 앱 전역 스타일
│   ├── index.css             # 기본 CSS 리셋 및 변수
│   ├── vite-env.d.ts         # Vite 타입 정의
│   ├── components/           # 재사용 가능한 컴포넌트
│   │   ├── common/           # 공통 UI 컴포넌트
│   │   │   ├── Button/
│   │   │   │   ├── index.ts        # re-export
│   │   │   │   ├── Button.tsx      # 컴포넌트 구현
│   │   │   │   ├── Button.module.css # 컴포넌트 스타일
│   │   │   │   └── Button.test.tsx  # 컴포넌트 테스트
│   │   │   ├── Input/
│   │   │   │   ├── index.ts
│   │   │   │   ├── Input.tsx
│   │   │   │   ├── Input.module.css
│   │   │   │   └── Input.test.tsx
│   │   │   └── Layout/
│   │   │       ├── index.ts
│   │   │       ├── Layout.tsx
│   │   │       └── Layout.module.css
│   │   ├── todo/             # TODO 관련 컴포넌트
│   │   │   ├── TodoItem/
│   │   │   │   ├── index.ts
│   │   │   │   ├── TodoItem.tsx
│   │   │   │   ├── TodoItem.module.css
│   │   │   │   └── TodoItem.test.tsx
│   │   │   ├── TodoList/
│   │   │   │   ├── index.ts
│   │   │   │   ├── TodoList.tsx
│   │   │   │   ├── TodoList.module.css
│   │   │   │   └── TodoList.test.tsx
│   │   │   ├── TodoForm/
│   │   │   │   ├── index.ts
│   │   │   │   ├── TodoForm.tsx
│   │   │   │   ├── TodoForm.module.css
│   │   │   │   └── TodoForm.test.tsx
│   │   │   └── index.ts      # todo 컴포넌트 통합 export
│   │   ├── plant/            # 식물 관련 컴포넌트
│   │   │   ├── PlantView/
│   │   │   │   ├── index.ts
│   │   │   │   ├── PlantView.tsx
│   │   │   │   ├── PlantView.module.css
│   │   │   │   └── PlantView.test.tsx
│   │   │   ├── GrowthAnimation/
│   │   │   │   ├── index.ts
│   │   │   │   ├── GrowthAnimation.tsx
│   │   │   │   └── GrowthAnimation.module.css
│   │   │   ├── CelebrationMessage/
│   │   │   │   ├── index.ts
│   │   │   │   ├── CelebrationMessage.tsx
│   │   │   │   └── CelebrationMessage.module.css
│   │   │   └── index.ts
│   │   └── dashboard/        # 대시보드 컴포넌트
│   │       ├── Dashboard/
│   │       │   ├── index.ts
│   │       │   ├── Dashboard.tsx
│   │       │   └── Dashboard.module.css
│   │       └── index.ts
│   ├── pages/                # 페이지 컴포넌트 (라우터)
│   │   ├── HomePage/
│   │   │   ├── index.ts
│   │   │   ├── HomePage.tsx
│   │   │   └── HomePage.module.css
│   │   └── index.ts
│   ├── hooks/                # 커스텀 React Hook
│   │   ├── useTodos.ts
│   │   ├── usePlant.ts
│   │   ├── useGrowthAnimation.ts
│   │   └── index.ts
│   ├── services/             # API 서비스
│   │   ├── api.ts           # axios 인스턴스 설정
│   │   ├── todoService.ts   # TODO API 호출
│   │   ├── plantService.ts  # Plant API 호출
│   │   └── index.ts
│   ├── types/                # TypeScript 타입 정의
│   │   ├── Todo.ts
│   │   ├── Plant.ts
│   │   ├── Api.ts
│   │   └── index.ts
│   ├── utils/                # 유틸리티 함수
│   │   ├── errorHandler.ts  # 에러 처리
│   │   ├── dateFormatter.ts # 날짜 포매팅
│   │   ├── plantGrowth.ts   # 식물 성장 계산
│   │   └── index.ts
│   ├── styles/               # 전역 스타일
│   │   ├── globals.css      # CSS 변수 및 전역 스타일
│   │   ├── animations.css   # 애니메이션 키프레임
│   │   └── themes.css       # 색상 테마 (선택적)
│   └── constants/            # 상수 정의
│       ├── apiEndpoints.ts  # API 엔드포인트
│       ├── plantStages.ts   # 식물 성장 단계
│       └── index.ts
├── dist/                     # Vite 빌드 결과
├── node_modules/             # npm 의존성
└── coverage/                 # 테스트 커버리지 리포트
```

## File Naming Conventions

### Backend (Java)
- **Classes**: PascalCase (`TodoController`, `PlantService`)
- **Interfaces**: PascalCase (`TodoRepository`)
- **Methods**: camelCase (`createTodo`, `findAllTodos`)
- **Variables**: camelCase (`todoTitle`, `createdAt`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_TITLE_LENGTH`)
- **Packages**: lowercase (`controller`, `service`, `repository`)

### Frontend (TypeScript/React)
- **Components**: PascalCase (`TodoItem`, `PlantView`)
- **Files**: PascalCase for components (`TodoItem.tsx`)
- **Hooks**: camelCase with `use` prefix (`useTodos`, `usePlant`)
- **Types/Interfaces**: PascalCase (`Todo`, `Plant`)
- **Functions**: camelCase (`handleComplete`, `formatDate`)
- **Constants**: UPPER_SNAKE_CASE (`API_BASE_URL`)
- **CSS Classes**: camelCase (`todoItem`, `completeButton`)

### General Files
- **Config Files**: kebab-case (`docker-compose.yml`, `vite.config.ts`)
- **Documentation**: kebab-case (`coding-standards.md`, `tech-stack.md`)
- **Scripts**: kebab-case (`dev-start.sh`, `build-all.sh`)

## Import/Export Patterns

### Backend Imports
```java
// 표준 라이브러리 먼저
import java.time.LocalDateTime;
import java.util.List;

// 써드파티 라이브러리
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

// 프로젝트 내부 import
import com.study.todolist.model.Todo;
import com.study.todolist.repository.TodoRepository;
```

### Frontend Exports
```typescript
// 컴포넌트 폴더의 index.ts
export { TodoItem } from './TodoItem';
export type { TodoItemProps } from './TodoItem';

// 상위 레벨 index.ts (barrel export)
export * from './TodoItem';
export * from './TodoList';
export * from './TodoForm';
```

## Environment Configuration

### Environment Files
```
backend/src/main/resources/
├── application.yml              # 기본 설정
├── application-dev.yml         # 개발 환경
├── application-test.yml        # 테스트 환경
└── application-prod.yml        # 운영 환경 (나중에)

frontend/
├── .env                        # 기본 환경변수
├── .env.development           # 개발 환경
└── .env.production           # 운영 환경
```

### Environment Variables
```bash
# Backend (application.yml)
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_DATABASE=todolist
MYSQL_USERNAME=root
MYSQL_PASSWORD=root

# Frontend (.env)
VITE_API_BASE_URL=http://localhost:8080
VITE_APP_NAME=GrowTogether TodoList
```

## Build Artifacts

### Generated Directories (Git Ignored)
```
backend/target/                 # Maven 빌드 결과
frontend/dist/                  # Vite 빌드 결과
frontend/node_modules/          # npm 의존성
frontend/coverage/              # 테스트 커버리지
build-output/                   # 전체 빌드 결과 (scripts)
.ai/debug.log                   # AI 디버그 로그
logs/                           # 애플리케이션 로그
*.log                           # 로그 파일들
```

## Migration Strategy

새로운 파일을 추가할 때:

1. **적절한 디렉토리** 확인
2. **명명 규칙** 준수
3. **index.ts** 파일 업데이트 (프론트엔드)
4. **테스트 파일** 함께 생성
5. **문서화** (필요시)

이 구조를 따라 일관된 프로젝트 구성을 유지하세요.