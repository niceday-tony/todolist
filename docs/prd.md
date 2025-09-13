# GrowTogether TodoList Product Requirements Document (PRD)

## Goals and Background Context

### Goals
- 기존 TodoList의 무미건조하고 딱딱한 사용자 경험을 감정적이고 따뜻한 경험으로 혁신
- 할 일 완료에 대한 즉각적이고 의미 있는 감정적 보상 시스템 구현
- 현대인의 외로움 문제를 해결하는 디지털 동반자 관계 형성
- 1일 개발 제약 내에서 Java17/Spring Boot + React로 MVP 구현
- 기존 TodoList 대비 사용자 지속률 40% 이상 향상
- 성취를 함께 기뻐할 수 있는 식물 동반자 시스템 완성

### Background Context
기존 TodoList 애플리케이션들의 가장 큰 문제점은 기능적 완성도에만 집중하여 사용자의 감정적 니즈를 간과했다는 것입니다. 체크박스 클릭으로 끝나는 무미건조한 상호작용과 지나치게 실용적인 UI/UX로 인해 사용자들은 성취감보다는 피로감을 더 많이 느끼고 있습니다.

브레인스토밍을 통해 발견한 핵심 인사이트는 "성취를 함께 기뻐해줄 존재의 필요성"입니다. 특히 혼자 일하고 생활하는 현대인들에게는 할 일 완료라는 작은 성취도 인정받고 싶은 욕구가 있으며, 이를 디지털 식물 동반자를 통해 해결하고자 합니다.

### Change Log
| Date | Version | Description | Author |
|------|---------|-------------|---------|
| 2025-09-13 | 1.0 | Initial PRD creation based on project brief | PM John |

## Requirements

### Functional

**FR1:** TODO 항목 기본 관리 - 사용자는 TODO를 생성, 수정, 삭제, 완료 처리할 수 있어야 함

**FR2:** 식물 동반자 시스템 - 각 사용자는 고유한 가상 식물을 가지며, TODO 완료시마다 식물이 단계별로 성장함

**FR3:** 식물 성장 단계 관리 - 식물은 최소 5단계 이상의 성장 과정을 가지며, 각 단계는 시각적으로 구별 가능해야 함

**FR4:** 즉각적 시각 피드백 - TODO 완료 즉시 식물 성장 애니메이션과 축하 메시지가 표시되어야 함

**FR5:** 데이터 영구 저장 - 사용자의 TODO 데이터와 식물의 성장 상태가 MySQL 데이터베이스에 영구적으로 저장되어야 함

**FR6:** 감정적 응답 메시지 - 식물이 TODO 완료에 대해 다양한 응원 메시지로 반응해야 함

### Non Functional

**NFR1:** 1일 개발 제약 - 모든 MVP 기능은 8시간 내에 구현 가능해야 함

**NFR2:** 기술 스택 준수 - Java17/Spring Boot + MySQL (백엔드) + React (프론트엔드) 조합으로 구현되어야 함

**NFR3:** 반응성 보장 - TODO 완료 후 식물 성장 피드백은 1초 이내에 표시되어야 함

**NFR4:** 브라우저 호환성 - Chrome, Firefox, Safari 최신 버전에서 정상 작동해야 함

**NFR5:** Docker 환경 지원 - MySQL은 기존 docker-compose.yml을 활용하여 컨테이너로 실행되어야 함

**NFR6:** 애니메이션 성능 - 식물 성장 애니메이션은 60fps를 유지하며 부드럽게 동작해야 함

## User Interface Design Goals

### Overall UX Vision
GrowTogether는 차가운 기계적 인터페이스가 아닌 따뜻하고 생동감 있는 디지털 가든 경험을 제공합니다. 사용자가 앱을 열었을 때 마치 자신의 작은 화분을 보살피는 듯한 친밀감을 느끼도록 디자인되며, 모든 상호작용이 식물과의 감정적 유대감을 강화하는 방향으로 설계됩니다. 단순함 속에서도 감정적 깊이가 있는 인터페이스를 추구합니다.

### Key Interaction Paradigms
- **성장 중심 인터랙션**: 모든 사용자 액션이 식물의 성장과 연결되어 즉각적인 시각적 피드백 제공
- **부드러운 애니메이션**: 식물 성장, TODO 체크, 메시지 표시 등 모든 전환이 자연스럽고 기쁨을 주는 애니메이션
- **최소한의 클릭**: 복잡한 메뉴나 다단계 프로세스 없이 직관적이고 간단한 상호작용
- **감정적 응답**: 사용자 행동에 대한 식물의 반응과 메시지로 일방향이 아닌 대화적 경험 제공

### Core Screens and Views
- **메인 대시보드**: 식물과 할 일 목록이 함께 표시되는 통합 화면
- **TODO 관리 화면**: 새 할 일 추가, 편집, 삭제 기능
- **식물 상태 화면**: 현재 식물의 성장 단계와 상태 세부 정보
- **성취 축하 화면**: TODO 완료시 나타나는 식물 성장 애니메이션과 축하 메시지

### Accessibility: WCAG AA
모든 사용자가 식물 동반자의 따뜻함을 느낄 수 있도록 WCAG 2.1 AA 수준의 접근성을 보장합니다. 색상뿐만 아니라 애니메이션과 텍스트로도 식물의 상태와 성장을 인지할 수 있도록 설계하며, 스크린 리더 사용자도 성취감을 충분히 경험할 수 있는 대체 텍스트와 피드백을 제공합니다.

### Branding
자연스럽고 편안한 느낌의 색상 팔레트를 사용하여 식물과 성장이라는 컨셉을 시각적으로 강화합니다. 주색상은 생명력 있는 초록색 계열을 중심으로 하되, 지나치게 밝거나 인위적이지 않은 차분한 톤을 유지합니다. 타이포그래피는 친근하면서도 읽기 쉬운 서체를 선택하여 디지털 동반자의 따뜻한 성격을 표현합니다.

### Target Device and Platforms: Web Responsive
데스크톱을 주요 타겟으로 하되 모바일에서도 핵심 기능 사용이 가능하도록 반응형 웹 디자인으로 구현합니다. 식물 애니메이션은 화면 크기에 관계없이 감정적 임팩트를 유지하도록 최적화되며, 터치 인터페이스에서도 자연스러운 상호작용이 가능하도록 설계됩니다.

## Technical Assumptions

### Repository Structure: Monorepo
단일 저장소에서 백엔드와 프론트엔드를 함께 관리합니다. 1일 개발 제약과 작은 팀 규모를 고려할 때, 코드 공유와 배포 단순화의 이점이 분리된 저장소의 복잡성보다 크다고 판단했습니다.

### Service Architecture
**모놀리식 아키텍처**를 채택합니다. Spring Boot 단일 애플리케이션으로 REST API를 제공하며, React SPA가 이를 소비하는 구조입니다. MVP 단계에서는 단순함이 확장성보다 중요하며, 향후 필요시 마이크로서비스로 분해할 수 있습니다.

**핵심 결정 근거**: 1일 제약 하에서 서비스 간 통신, 배포 복잡성, 트랜잭션 관리 등의 오버헤드를 최소화하기 위함

### Testing Requirements
**Unit + Integration 테스팅** 전략을 적용합니다. Spring Boot의 `@SpringBootTest`와 React Testing Library를 활용하여 핵심 비즈니스 로직과 주요 사용자 시나리오를 검증합니다. E2E 테스트는 시간 제약으로 제외하되, 수동 테스트용 편의 기능을 제공합니다.

**구체적 테스트 범위**:
- 백엔드: TODO CRUD, 식물 성장 로직, 데이터베이스 연동
- 프론트엔드: 컴포넌트 렌더링, 애니메이션 트리거, API 통신

### Additional Technical Assumptions and Requests

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

## Epic List

**Epic 1: Foundation & Plant Companion Core**
프로젝트 기반 인프라 구축과 핵심 식물 동반자 시스템을 동시에 구현하여 즉시 감정적 가치를 체험할 수 있는 기본 기능 제공

**Epic 2: Enhanced User Experience & Polish**
사용자 경험 개선과 감정적 연결 강화를 위한 고급 피드백 시스템 및 인터페이스 완성

## Epic 1: Foundation & Plant Companion Core

**목표**: 프로젝트 기반 인프라를 구축하고 핵심 식물 동반자 시스템을 구현하여 사용자가 TODO 완료와 식물 성장의 연결을 즉시 체험할 수 있도록 합니다. 이 에픽만으로도 완전한 감정적 보상 사이클이 작동하는 최소 기능 제품을 제공합니다.

### Story 1.1: Project Foundation & Database Setup

As a **developer**,
I want **to establish the project infrastructure with database connectivity**,
so that **the application can persist TODO and plant data reliably**.

#### Acceptance Criteria
1. Spring Boot 프로젝트가 생성되고 기본 웹 서버가 실행됨
2. MySQL 데이터베이스 연결이 설정되고 테스트됨 (docker-compose.yml 활용)
3. TODO와 Plant 엔티티를 위한 JPA 모델과 테이블이 생성됨
4. 기본 REST API 엔드포인트(/health)가 작동하여 시스템 상태 확인 가능
5. React 프로젝트가 생성되고 백엔드 API와 통신 테스트 완료

### Story 1.2: Basic TODO Management

As a **user**,
I want **to create, view, and mark TODOs as complete**,
so that **I can manage my daily tasks efficiently**.

#### Acceptance Criteria
1. 새로운 TODO 항목을 텍스트로 입력하고 저장할 수 있음
2. 저장된 TODO 목록이 화면에 표시됨
3. TODO 항목을 클릭하여 완료 상태로 변경할 수 있음
4. 완료된 TODO는 시각적으로 구별됨 (체크 표시, 줄 그기 등)
5. TODO 데이터가 MySQL 데이터베이스에 영구 저장됨

### Story 1.3: Plant Companion System

As a **user**,
I want **to have a virtual plant that grows when I complete TODOs**,
so that **I feel emotional reward and companionship from my achievements**.

#### Acceptance Criteria
1. 사용자마다 고유한 식물 인스턴스가 생성됨
2. 식물은 최소 5단계의 성장 단계를 가짐 (씨앗 → 새싹 → 어린 식물 → 성장한 식물 → 완전한 식물)
3. TODO 완료시 식물의 성장 포인트가 증가하고 단계별로 진화함
4. 각 성장 단계는 시각적으로 명확히 구별되는 이미지나 CSS로 표현됨
5. 식물 상태(성장 포인트, 현재 단계)가 데이터베이스에 저장됨

### Story 1.4: Growth Animation & Feedback

As a **user**,
I want **to see immediate visual feedback when my plant grows**,
so that **I feel joy and accomplishment from completing TODOs**.

#### Acceptance Criteria
1. TODO 완료 버튼 클릭시 1초 이내에 성장 애니메이션이 시작됨
2. 식물 성장 애니메이션이 부드럽고 자연스럽게 표시됨 (CSS transition 활용)
3. 성장시 축하 메시지가 함께 표시됨 ("잘했어요! 식물이 기뻐해요!" 등)
4. 현재 성장 단계와 다음 단계까지의 진행률이 표시됨
5. 애니메이션 완료 후 새로운 식물 상태가 지속적으로 화면에 유지됨

### Story 1.5: Integrated Dashboard UI

As a **user**,
I want **to see my TODOs and plant together on one screen**,
so that **I can easily understand the connection between my tasks and plant growth**.

#### Acceptance Criteria
1. 메인 화면에서 TODO 목록과 식물이 나란히 표시됨
2. 화면 레이아웃이 모바일과 데스크톱에서 모두 적절히 표시됨
3. TODO 완료시 식물 영역에서 즉시 시각적 변화가 관찰 가능함
4. 전체 UI가 자연스럽고 따뜻한 느낌의 색상과 디자인 적용됨
5. 기본적인 WCAG AA 접근성 기준 준수 (색상 대비, alt 텍스트 등)

## Epic 2: Enhanced User Experience & Polish

**목표**: Epic 1의 기본 기능 위에 감정적 연결을 강화하고 사용자 지속성을 높이는 고급 피드백 시스템과 세련된 사용자 경험을 구현합니다. 이 에픽은 시간 여유가 있을 때 실행하여 제품을 한 단계 더 완성도 높게 만듭니다.

### Story 2.1: Enhanced Plant Reactions

As a **user**,
I want **my plant to show varied reactions and personality**,
so that **I feel a deeper emotional connection with my digital companion**.

#### Acceptance Criteria
1. TODO 완료시 식물이 다양한 반응 메시지를 표시함 (최소 5가지 변형)
2. 연속으로 TODO를 완료할 때 특별한 축하 메시지가 나타남
3. 식물의 현재 기분이나 상태가 시각적으로 표현됨 (흔들림, 색상 변화 등)
4. 하루 동안 TODO를 완료하지 않으면 식물이 심심해하는 표현을 보임
5. 모든 메시지가 친근하고 격려적인 톤으로 작성됨

### Story 2.2: Plant Customization

As a **user**,
I want **to personalize my plant companion**,
so that **I feel ownership and deeper attachment to my digital friend**.

#### Acceptance Criteria
1. 식물에게 이름을 지어줄 수 있음
2. 식물 이름이 모든 메시지와 인터페이스에 반영됨
3. 식물의 화분이나 배경을 간단하게 꾸밀 수 있음 (2-3가지 옵션)
4. 설정한 개인화 정보가 데이터베이스에 저장됨
5. 개인화 설정 화면이 직관적이고 사용하기 쉬움

### Story 2.3: Achievement System

As a **user**,
I want **to unlock milestones and see my progress over time**,
so that **I stay motivated to continue using the app**.

#### Acceptance Criteria
1. TODO 완료 개수에 따른 성취 뱃지가 표시됨 (5개, 10개, 20개 등)
2. 연속 사용일에 대한 성취도 추적됨
3. 식물이 특정 성장 단계에 도달했을 때 특별한 축하 화면이 나타남
4. 성취 현황을 볼 수 있는 별도 화면이나 섹션이 제공됨
5. 각 성취에 대한 의미 있는 설명과 격려 메시지가 포함됨

### Story 2.4: Improved Visual Polish

As a **user**,
I want **a more refined and delightful visual experience**,
so that **using the app feels premium and enjoyable**.

#### Acceptance Criteria
1. 모든 애니메이션이 부드럽고 자연스럽게 동작함 (easing 함수 적용)
2. 버튼 클릭, 호버 효과 등 마이크로 인터랙션이 적용됨
3. 로딩 상태나 에러 상황에 대한 적절한 피드백이 제공됨
4. 전체 UI의 색상, 타이포그래피, 간격이 일관성 있게 적용됨
5. 다양한 화면 크기에서 레이아웃이 깨지지 않고 적절히 표시됨

## Checklist Results Report

체크리스트를 실행하여 PRD 품질을 검증하겠습니다.

## Next Steps

### UX Expert Prompt
UX Expert 모드로 전환하여 이 PRD를 기반으로 사용자 경험 아키텍처와 인터페이스 디자인을 시작해주세요.

### Architect Prompt
Architect 모드로 전환하여 이 PRD를 기반으로 기술 아키텍처 설계를 시작해주세요.

---

*이 문서는 2025-09-13 작성되었으며, 프로젝트 브리프와 브레인스토밍 결과를 바탕으로 작성되었습니다.*