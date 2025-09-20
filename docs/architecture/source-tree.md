# 소스 트리 구조 가이드

## 개요

"감성적인 할일 목록" 프로젝트의 전체 디렉토리 구조와 파일 조직을 정의합니다. 5명의 개발자가 일관성 있게 프로젝트를 이해하고 작업할 수 있도록 명확한 구조를 제공합니다.

## 프로젝트 루트 구조

```
todolist/
├── .bmad-core/                    # BMad 프레임워크 설정 및 템플릿
├── .claude/                       # Claude Code AI 설정
├── .gemini/                       # Gemini AI 설정
├── .idea/                         # IntelliJ IDEA 설정
├── backend/                       # Spring Boot 백엔드 애플리케이션
├── frontend/                      # Next.js 프론트엔드 애플리케이션
├── docs/                          # 프로젝트 문서
├── docker-compose.yml             # Docker 컴포즈 설정
├── init.sql                       # 데이터베이스 초기화 스크립트
├── README.md                      # 프로젝트 개요
├── CLAUDE.md                      # AI 협업 가이드
├── LICENSE                        # 라이선스
└── .gitignore                     # Git 무시 파일 목록
```

## 백엔드 구조 (Spring Boot)

```
backend/
├── .gradle/                       # Gradle 캐시 (Git 무시)
├── gradle/
│   └── wrapper/                   # Gradle Wrapper 파일
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── study/
│   │   │           └── todolist/
│   │   │               ├── controller/      # REST API 컨트롤러
│   │   │               ├── service/         # 비즈니스 로직
│   │   │               ├── repository/      # 데이터 액세스
│   │   │               ├── entity/          # JPA 엔티티
│   │   │               ├── dto/             # 데이터 전송 객체
│   │   │               ├── config/          # 설정 클래스
│   │   │               ├── exception/       # 예외 처리
│   │   │               └── TodolistApplication.java
│   │   └── resources/
│   │       ├── application.yml              # 기본 설정
│   │       ├── application-local.yml        # 로컬 개발용
│   │       ├── application-test.yml         # 테스트용
│   │       └── static/                      # 정적 리소스
│   └── test/
│       └── java/
│           └── com/
│               └── study/
│                   └── todolist/
│                       ├── controller/      # 컨트롤러 테스트
│                       ├── service/         # 서비스 테스트
│                       ├── repository/      # 리포지토리 테스트
│                       └── TodolistApplicationTests.java
├── build.gradle                   # Gradle 빌드 설정
├── settings.gradle                # Gradle 프로젝트 설정
├── gradlew                        # Gradle Wrapper (Unix)
├── gradlew.bat                    # Gradle Wrapper (Windows)
└── HELP.md                        # Spring Boot 도움말
```

### 백엔드 패키지별 역할

#### controller 패키지
```java
// 예상 파일 구조
com.study.todolist.controller/
├── TodoController.java            # 할일 관련 REST API
├── UserController.java            # 사용자 관련 REST API (향후)
├── AuthController.java            # 인증 관련 REST API (향후)
└── BaseController.java            # 공통 컨트롤러 로직
```

#### service 패키지
```java
com.study.todolist.service/
├── TodoService.java               # 할일 비즈니스 로직
├── UserService.java               # 사용자 비즈니스 로직 (향후)
└── AuthService.java               # 인증 비즈니스 로직 (향후)
```

#### repository 패키지
```java
com.study.todolist.repository/
├── TodoRepository.java            # 할일 데이터 액세스
└── UserRepository.java            # 사용자 데이터 액세스 (향후)
```

#### entity 패키지
```java
com.study.todolist.entity/
├── Todo.java                      # 할일 엔티티
├── User.java                      # 사용자 엔티티 (향후)
└── BaseEntity.java                # 공통 엔티티 필드
```

#### dto 패키지
```java
com.study.todolist.dto/
├── request/
│   ├── TodoCreateRequest.java     # 할일 생성 요청
│   ├── TodoUpdateRequest.java     # 할일 수정 요청
│   └── UserCreateRequest.java     # 사용자 생성 요청 (향후)
├── response/
│   ├── TodoResponse.java          # 할일 응답
│   ├── UserResponse.java          # 사용자 응답 (향후)
│   └── ApiResponse.java           # 공통 API 응답 래퍼
└── mapper/
    ├── TodoMapper.java            # Todo 엔티티 ↔ DTO 매핑
    └── UserMapper.java            # User 엔티티 ↔ DTO 매핑 (향후)
```

## 프론트엔드 구조 (Next.js)

```
frontend/
├── node_modules/                  # npm 패키지 (Git 무시)
├── public/                        # 정적 파일
│   ├── images/                    # 이미지 파일
│   ├── icons/                     # 아이콘 파일
│   └── favicon.ico                # 파비콘
├── src/
│   ├── app/                       # Next.js 13+ App Router
│   │   ├── globals.css            # 전역 스타일
│   │   ├── layout.tsx             # 루트 레이아웃
│   │   ├── page.tsx               # 홈 페이지
│   │   ├── todos/                 # 할일 관련 페이지
│   │   │   ├── page.tsx           # 할일 목록 페이지
│   │   │   ├── [id]/              # 동적 라우팅
│   │   │   │   └── page.tsx       # 할일 상세 페이지
│   │   │   └── create/
│   │   │       └── page.tsx       # 할일 생성 페이지
│   │   └── api/                   # API Routes (필요시)
│   ├── components/                # 재사용 가능한 컴포넌트
│   │   ├── ui/                    # 기본 UI 컴포넌트
│   │   │   ├── Button.tsx
│   │   │   ├── Input.tsx
│   │   │   ├── Modal.tsx
│   │   │   └── LoadingSpinner.tsx
│   │   ├── todo/                  # 할일 관련 컴포넌트
│   │   │   ├── TodoItem.tsx
│   │   │   ├── TodoList.tsx
│   │   │   ├── TodoForm.tsx
│   │   │   └── TodoFilter.tsx
│   │   └── layout/                # 레이아웃 컴포넌트
│   │       ├── Header.tsx
│   │       ├── Footer.tsx
│   │       └── Navigation.tsx
│   ├── hooks/                     # 커스텀 훅
│   │   ├── useTodos.ts            # 할일 관련 훅
│   │   ├── useApi.ts              # API 호출 훅
│   │   └── useLocalStorage.ts     # 로컬 스토리지 훅
│   ├── services/                  # API 호출 서비스
│   │   ├── api.ts                 # Axios 설정
│   │   ├── todoService.ts         # 할일 API 서비스
│   │   └── userService.ts         # 사용자 API 서비스 (향후)
│   ├── types/                     # TypeScript 타입 정의
│   │   ├── Todo.ts                # 할일 타입
│   │   ├── User.ts                # 사용자 타입 (향후)
│   │   └── Api.ts                 # API 응답 타입
│   ├── utils/                     # 유틸리티 함수
│   │   ├── formatDate.ts          # 날짜 포맷팅
│   │   ├── validation.ts          # 유효성 검사
│   │   └── constants.ts           # 상수 정의
│   └── styles/                    # 스타일 파일
│       ├── globals.css            # 전역 스타일
│       └── components/            # 컴포넌트별 스타일
├── .env.local                     # 로컬 환경 변수
├── .env.example                   # 환경 변수 예시
├── next.config.js                 # Next.js 설정
├── package.json                   # npm 패키지 설정
├── package-lock.json              # 패키지 락 파일
├── tailwind.config.js             # Tailwind CSS 설정
├── tsconfig.json                  # TypeScript 설정
└── README.md                      # 프론트엔드 가이드
```

## 문서 구조

```
docs/
├── architecture/                  # 아키텍처 문서
│   ├── coding-standards.md        # 코딩 표준
│   ├── tech-stack.md              # 기술 스택
│   └── source-tree.md             # 소스 트리 구조 (현재 파일)
├── api/                           # API 문서 (향후)
│   ├── todo-api.md                # 할일 API 명세
│   └── user-api.md                # 사용자 API 명세 (향후)
├── deployment/                    # 배포 관련 문서 (향후)
│   ├── docker-guide.md            # Docker 배포 가이드
│   └── production-setup.md        # 프로덕션 환경 설정
├── architecture.md                # 전체 아키텍처 문서
├── prd.md                         # 제품 요구사항 문서
├── front-end-spec.md              # 프론트엔드 명세
└── brainstorming-session-results.md # 브레인스토밍 결과
```

## 설정 파일 디렉토리

### AI 협업 설정
```
.bmad-core/                        # BMad 프레임워크
├── agents/                        # AI 에이전트 정의
├── tasks/                         # 작업 템플릿
├── templates/                     # 문서 템플릿
└── core-config.yaml               # 핵심 설정

.claude/                           # Claude Code 설정
└── commands/
    └── BMad/                      # BMad 명령어

.gemini/                           # Gemini AI 설정
└── commands/
    └── BMad/                      # BMad 명령어
```

### 개발 환경 설정
```
.idea/                             # IntelliJ IDEA 설정
├── dataSources.xml                # 데이터베이스 연결
├── modules.xml                    # 모듈 설정
└── workspace.xml                  # 작업공간 설정
```

## 파일 명명 규칙

### 백엔드 (Java)
- **클래스 파일**: PascalCase (예: `TodoController.java`)
- **패키지 디렉토리**: lowercase (예: `controller/`, `service/`)
- **테스트 파일**: `{클래스명}Test.java` (예: `TodoControllerTest.java`)

### 프론트엔드 (TypeScript/React)
- **컴포넌트 파일**: PascalCase (예: `TodoItem.tsx`)
- **훅 파일**: camelCase with 'use' prefix (예: `useTodos.ts`)
- **서비스 파일**: camelCase (예: `todoService.ts`)
- **타입 파일**: PascalCase (예: `Todo.ts`)
- **유틸리티 파일**: camelCase (예: `formatDate.ts`)

### 문서 파일
- **일반 문서**: kebab-case (예: `coding-standards.md`)
- **API 문서**: `{리소스명}-api.md` (예: `todo-api.md`)
- **가이드 문서**: `{주제}-guide.md` (예: `docker-guide.md`)

## Git 워크플로우와 브랜치 구조

### 브랜치 전략
```
main                               # 메인 브랜치 (배포용)
├── develop                        # 개발 브랜치
│   ├── feature/todo-crud          # 기능 개발 브랜치
│   ├── feature/user-auth          # 기능 개발 브랜치
│   ├── fix/api-error-handling     # 버그 수정 브랜치
│   └── refactor/component-structure # 리팩토링 브랜치
└── hotfix/critical-bug            # 긴급 수정 브랜치
```

### 무시할 파일/디렉토리 (.gitignore)
```gitignore
# Compiled output
/backend/build/
/backend/target/
/frontend/.next/
/frontend/out/

# Dependencies
/backend/.gradle/
/frontend/node_modules/

# IDE
.idea/
.vscode/
*.swp
*.swo

# Environment variables
.env.local
.env.production

# Logs
*.log
logs/

# Database
*.db
*.sqlite

# OS generated files
.DS_Store
Thumbs.db
```

## 향후 확장 계획

### 추가 예정 디렉토리
```
todolist/
├── mobile/                        # React Native 모바일 앱 (향후)
├── desktop/                       # Electron 데스크탑 앱 (향후)
├── scripts/                       # 빌드/배포 스크립트
├── tests/                         # E2E 테스트
├── k8s/                           # Kubernetes 설정 (향후)
└── terraform/                     # 인프라 설정 (향후)
```

### 마이크로서비스 확장 (향후)
```
services/
├── todo-service/                  # 할일 마이크로서비스
├── user-service/                  # 사용자 마이크로서비스
├── notification-service/          # 알림 마이크로서비스
└── api-gateway/                   # API 게이트웨이
```

## 개발자별 작업 영역 가이드

### 백엔드 개발자 (4명)
- **주요 작업 디렉토리**: `backend/src/main/java/com/study/todolist/`
- **테스트 디렉토리**: `backend/src/test/java/com/study/todolist/`
- **설정 파일**: `backend/src/main/resources/`

### 프론트엔드 개발자 (1명)
- **주요 작업 디렉토리**: `frontend/src/`
- **컴포넌트**: `frontend/src/components/`
- **페이지**: `frontend/src/app/`
- **스타일**: `frontend/src/styles/`

### 공통 작업 영역
- **문서**: `docs/`
- **설정**: 루트 디렉토리의 설정 파일들
- **AI 설정**: `.bmad-core/`, `.claude/`

---

*이 소스 트리 구조는 프로젝트 발전에 따라 지속적으로 업데이트됩니다.*