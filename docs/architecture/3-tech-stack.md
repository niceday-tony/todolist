# 3. Tech Stack

## Technology Stack Table

| Category | Technology | Version | Purpose | Rationale |
| :--- | :--- | :--- | :--- | :--- |
| Frontend Language | TypeScript | 5.x | 타입 안정성, 코드 유지보수성 | JavaScript에 타입을 추가하여 개발 중 오류를 줄이고, 코드의 가독성과 유지보수성을 높입니다. |
| Frontend Framework | Next.js | 14.x | UI 렌더링, SPA 라우팅 | React 기반 프레임워크로, 빠른 개발 속도와 강력한 개발 서버 기능을 제공합니다. |
| UI Component Library | Material-UI (MUI) | 5.x | UI 컴포넌트 | `front-end-spec.md`에서 언급된 대로, 성숙하고 풍부한 컴포넌트를 제공하여 UI 개발을 가속화합니다. |
| State Management | Zustand | 4.x | 프론트엔드 상태 관리 | 간단하고 직관적인 API를 제공하여, MVP 단계에서 빠르고 효율적인 상태 관리를 가능하게 합니다. |
| Backend Language | Java | 17 | 백엔드 비즈니스 로직 | 안정적이고 성숙한 언어이며, Spring Boot 프레임워크와의 호환성이 뛰어납니다. |
| Backend Framework | Spring Boot | 3.x | REST API 서버 구축 | `application.yml`에서 확인된 대로, 빠르고 쉽게 독립 실행형 애플리케이션을 만들 수 있습니다. |
| API Style | REST | | 클라이언트-서버 통신 | 표준적이고 널리 사용되는 방식으로, 명확한 자원 기반의 상호작용을 정의합니다. |
| Database | MySQL | 8.0 | 데이터 영속성 | `docker-compose.yml`에서 확인된 대로, 신뢰성 높고 널리 사용되는 관계형 데이터베이스입니다. |
| Authentication | Spring Security | 6.x | 인증 및 인가 | Spring 생태계의 표준 보안 프레임워크로, 강력하고 유연한 보안 기능을 제공합니다. |
| Frontend Testing | Jest + RTL | latest | 프론트엔드 단위/통합 테스트 | React 애플리케이션 테스트를 위한 산업 표준 조합입니다. |
| Backend Testing | JUnit 5 + Mockito | latest | 백엔드 단위/통합 테스트 | Spring Boot 애플리케이션 테스트를 위한 표준 조합입니다. |
| E2E Testing | Playwright | latest | End-to-End 테스트 | 모든 주요 브라우저를 지원하며, 빠르고 안정적인 E2E 테스트를 가능하게 합니다. |
| Build Tool | Gradle / npm | latest | 의존성 관리 및 빌드 | 각각 백엔드와 프론트엔드의 표준 빌드 도구입니다. |
| Bundler | Webpack | 5.x | 프론트엔드 에셋 번들링 | Next.js에 내장되어 있으며, 코드 최적화 및 번들링을 자동으로 처리합니다. |
| IaC Tool | Docker Compose | | 로컬 개발 환경 구성 | `docker-compose.yml`을 통해 로컬 개발 환경을 일관되게 관리합니다. |
| Logging | SLF4J + Logback | | 백엔드 로깅 | Spring Boot의 표준 로깅 구현체로, 유연한 로깅 설정을 제공합니다. |
| CSS Framework | Emotion | 11.x | UI 스타일링 | Material-UI의 기본 스타일링 엔진으로, CSS-in-JS 방식을 통해 컴포넌트 기반 스타일링을 지원합니다. |

---
