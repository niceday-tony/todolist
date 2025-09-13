# Technical Assumptions

## Repository Structure: Monorepo
단일 저장소에서 백엔드와 프론트엔드를 함께 관리합니다. 1일 개발 제약과 작은 팀 규모를 고려할 때, 코드 공유와 배포 단순화의 이점이 분리된 저장소의 복잡성보다 크다고 판단했습니다.

## Service Architecture
**모놀리식 아키텍처**를 채택합니다. Spring Boot 단일 애플리케이션으로 REST API를 제공하며, React SPA가 이를 소비하는 구조입니다. MVP 단계에서는 단순함이 확장성보다 중요하며, 향후 필요시 마이크로서비스로 분해할 수 있습니다.

**핵심 결정 근거**: 1일 제약 하에서 서비스 간 통신, 배포 복잡성, 트랜잭션 관리 등의 오버헤드를 최소화하기 위함

## Testing Requirements
**Unit + Integration 테스팅** 전략을 적용합니다. Spring Boot의 `@SpringBootTest`와 React Testing Library를 활용하여 핵심 비즈니스 로직과 주요 사용자 시나리오를 검증합니다. E2E 테스트는 시간 제약으로 제외하되, 수동 테스트용 편의 기능을 제공합니다.

**구체적 테스트 범위**:
- 백엔드: TODO CRUD, 식물 성장 로직, 데이터베이스 연동
- 프론트엔드: 컴포넌트 렌더링, 애니메이션 트리거, API 통신

## Additional Technical Assumptions and Requests

**언어 및 프레임워크**:
- **백엔드**: Java 17 + Spring Boot 3.x + Spring Data JPA
- **프론트엔드**: React 18+ with TypeScript + Vite (빠른 개발 서버)
- **데이터베이스**: MySQL 8.0 (기존 docker-compose.yml 활용)

**라이브러리 및 도구**:
- **애니메이션**: CSS 애니메이션 + React Transition Group (가벼운 라이브러리)
- **스타일링**: CSS Modules 또는 styled-components (빠른 스타일링)
- **HTTP 통신**: Axios (React) + RestTemplate (Spring Boot)
- **빌드 도구**: Maven (백엔드) + Vite (프론트엔드)

**배포 및 환경**:
- **개발 환경**: Docker Compose로 MySQL 실행, 로컬에서 Spring Boot/React 개발 서버
- **초기 배포**: 로컬 JAR 실행 + React 빌드 파일 서빙
- **환경 설정**: application.yml로 데이터베이스 연결 정보 관리

**보안 고려사항**:
- 초기 MVP에서는 사용자 인증 시스템 제외 (단일 사용자 가정)
- CORS 설정으로 프론트엔드-백엔드 통신 허용
- SQL Injection 방지를 위한 JPA 쿼리 메소드 활용

**성능 최적화**:
- 식물 이미지는 SVG 또는 최적화된 PNG로 번들 크기 최소화
- React 상태 관리는 내장 useState/useEffect로 충분 (Redux 등 제외)
- 데이터베이스 쿼리 최적화를 위한 적절한 인덱스 설계
