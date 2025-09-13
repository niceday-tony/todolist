# Epic 1: Foundation & Plant Companion Core

**목표**: 프로젝트 기반 인프라를 구축하고 핵심 식물 동반자 시스템을 구현하여 사용자가 TODO 완료와 식물 성장의 연결을 즉시 체험할 수 있도록 합니다. 이 에픽만으로도 완전한 감정적 보상 사이클이 작동하는 최소 기능 제품을 제공합니다.

## Story 1.1: Project Foundation & Database Setup

As a **developer**,
I want **to establish the project infrastructure with database connectivity**,
so that **the application can persist TODO and plant data reliably**.

### Acceptance Criteria
1. Spring Boot 프로젝트가 생성되고 기본 웹 서버가 실행됨
2. MySQL 데이터베이스 연결이 설정되고 테스트됨 (docker-compose.yml 활용)
3. TODO와 Plant 엔티티를 위한 JPA 모델과 테이블이 생성됨
4. 기본 REST API 엔드포인트(/health)가 작동하여 시스템 상태 확인 가능
5. React 프로젝트가 생성되고 백엔드 API와 통신 테스트 완료

## Story 1.2: Basic TODO Management

As a **user**,
I want **to create, view, and mark TODOs as complete**,
so that **I can manage my daily tasks efficiently**.

### Acceptance Criteria
1. 새로운 TODO 항목을 텍스트로 입력하고 저장할 수 있음
2. 저장된 TODO 목록이 화면에 표시됨
3. TODO 항목을 클릭하여 완료 상태로 변경할 수 있음
4. 완료된 TODO는 시각적으로 구별됨 (체크 표시, 줄 그기 등)
5. TODO 데이터가 MySQL 데이터베이스에 영구 저장됨

## Story 1.3: Plant Companion System

As a **user**,
I want **to have a virtual plant that grows when I complete TODOs**,
so that **I feel emotional reward and companionship from my achievements**.

### Acceptance Criteria
1. 사용자마다 고유한 식물 인스턴스가 생성됨
2. 식물은 최소 5단계의 성장 단계를 가짐 (씨앗 → 새싹 → 어린 식물 → 성장한 식물 → 완전한 식물)
3. TODO 완료시 식물의 성장 포인트가 증가하고 단계별로 진화함
4. 각 성장 단계는 시각적으로 명확히 구별되는 이미지나 CSS로 표현됨
5. 식물 상태(성장 포인트, 현재 단계)가 데이터베이스에 저장됨

## Story 1.4: Growth Animation & Feedback

As a **user**,
I want **to see immediate visual feedback when my plant grows**,
so that **I feel joy and accomplishment from completing TODOs**.

### Acceptance Criteria
1. TODO 완료 버튼 클릭시 1초 이내에 성장 애니메이션이 시작됨
2. 식물 성장 애니메이션이 부드럽고 자연스럽게 표시됨 (CSS transition 활용)
3. 성장시 축하 메시지가 함께 표시됨 ("잘했어요! 식물이 기뻐해요!" 등)
4. 현재 성장 단계와 다음 단계까지의 진행률이 표시됨
5. 애니메이션 완료 후 새로운 식물 상태가 지속적으로 화면에 유지됨

## Story 1.5: Integrated Dashboard UI

As a **user**,
I want **to see my TODOs and plant together on one screen**,
so that **I can easily understand the connection between my tasks and plant growth**.

### Acceptance Criteria
1. 메인 화면에서 TODO 목록과 식물이 나란히 표시됨
2. 화면 레이아웃이 모바일과 데스크톱에서 모두 적절히 표시됨
3. TODO 완료시 식물 영역에서 즉시 시각적 변화가 관찰 가능함
4. 전체 UI가 자연스럽고 따뜻한 느낌의 색상과 디자인 적용됨
5. 기본적인 WCAG AA 접근성 기준 준수 (색상 대비, alt 텍스트 등)
