# 개발팀 역할 분담 계획

## 👥 팀 구성

### 백엔드 개발자 4명 + 프론트엔드 개발자 1명

## 🎯 역할 분담 전략

### 백엔드 개발자 분담 방식

#### **개발자 A**: API Controller 레이어
```
담당 범위:
- TodoController.java (REST API 엔드포인트)
- 글로벌 예외 처리 (GlobalExceptionHandler.java)
- API 응답 형식 (ErrorResponse, ApiResponse DTO)

핵심 작업:
- GET /api/todos
- POST /api/todos
- PUT /api/todos/{id}/toggle
- PUT /api/todos/{id}
- DELETE /api/todos/{id}
```

#### **개발자 B**: Service 비즈니스 로직
```
담당 범위:
- TodoService.java (핵심 비즈니스 로직)
- 격려 메시지 서비스 (EncouragementService.java)
- 비즈니스 예외 처리

핵심 작업:
- 할일 CRUD 비즈니스 로직
- 완료시 격려 메시지 생성
- 비즈니스 규칙 검증
```

#### **개발자 C**: Data 레이어
```
담당 범위:
- Todo Entity (JPA 엔티티)
- TodoRepository.java (데이터 액세스)
- 데이터베이스 스키마 및 초기화

핵심 작업:
- JPA 엔티티 설계
- 커스텀 쿼리 메서드
- init.sql 데이터베이스 초기화
- 데이터 매핑 (TodoMapper)
```

#### **개발자 D**: 설정 및 인프라
```
담당 범위:
- Spring Boot 설정 (application.yml)
- Docker 설정 (docker-compose.yml)
- 보안 설정 (Spring Security 기본)
- 빌드 및 배포 (build.gradle)

핵심 작업:
- 개발 환경 Docker 구성
- 데이터베이스 연결 설정
- CORS 설정
- 기본 보안 설정
```

### 프론트엔드 개발자 1명

#### **개발자 E**: 전체 프론트엔드
```
담당 범위:
- 모든 React 컴포넌트
- Zustand 상태 관리
- API 서비스 연동
- 감성 기능 (바질, 격려 메시지)

핵심 작업:
- TodoList, TodoItem, TodoForm 컴포넌트
- TodoStore, BasilStore 상태 관리
- API 서비스 (todoService.ts)
- 바질 화분 및 격려 메시지 UI
```

## 📅 개발 일정 (하루 개발)

### Phase 1: 환경 설정 (1-2시간)
```
전체팀: 개발 환경 설정 및 프로젝트 클론
- Git 브랜치 생성
- Docker 환경 설정
- 개발 도구 설정

개발자 D: Docker 및 인프라 우선 설정
```

### Phase 2: 백엔드 코어 개발 (3-4시간)
```
개발자 C: Entity + Repository → 가장 먼저 시작
개발자 B: Service 로직 → Entity 완료 후
개발자 A: Controller → Service 완료 후
개발자 D: 설정 및 통합 → 병렬 진행

목표: 백엔드 API 완전 동작
```

### Phase 3: 프론트엔드 개발 (3-4시간)
```
개발자 E: 백엔드 API 완료 후 시작
- 기본 컴포넌트 → API 연동 → 감성 기능

백엔드팀: 프론트엔드 지원 및 버그 수정
```

### Phase 4: 통합 및 테스트 (1-2시간)
```
전체팀: 통합 테스트 및 버그 수정
- 기능 테스트
- 사용자 시나리오 검증
- 최종 점검
```

## 🌿 브랜치 전략

### 메인 브랜치
```
main: 최종 배포용
develop: 통합 개발 브랜치
```

### 기능 브랜치
```
feature/backend-entity     (개발자 C)
feature/backend-service    (개발자 B)
feature/backend-controller (개발자 A)
feature/backend-config     (개발자 D)
feature/frontend-ui        (개발자 E)
```

## 🔄 협업 워크플로우

### 1단계: 브랜치 생성 및 작업
```bash
git checkout -b feature/backend-entity
# 개발 작업 진행
git add . && git commit -m "feat: Todo 엔티티 구현"
git push origin feature/backend-entity
```

### 2단계: Pull Request 생성
```
PR 제목: [Backend] Todo Entity 구현
리뷰어: 관련 개발자 1-2명 지정
체크리스트:
- [ ] 기본 테스트 통과
- [ ] 코딩 컨벤션 준수
- [ ] API 명세 준수
```

### 3단계: 리뷰 및 머지
```
빠른 리뷰: 30분 이내
즉시 머지: 문제 없으면 바로 develop에 머지
충돌 해결: 발생시 즉시 해결
```

## 📞 의사소통 채널

### 실시간 소통
```
- Slack/Discord: 즉시 질문 및 상황 공유
- 화면 공유: 문제 발생시 즉시 공유
- 15분 단위 체크인: 진행 상황 공유
```

### 이슈 추적
```
GitHub Issues:
- 버그 발견시 즉시 이슈 생성
- 담당자 지정 및 우선순위 설정
- 해결 후 즉시 클로즈
```

## 🚨 리스크 관리

### 주요 리스크와 대응방안

#### 백엔드 의존성 문제
```
리스크: Entity → Service → Controller 순서 의존
대응: 개발자 C가 먼저 시작, 나머지는 병렬 준비
```

#### 통합 충돌
```
리스크: 여러 명이 동시 작업시 충돌
대응: 자주 pull, 작은 단위로 커밋
```

#### 프론트엔드 대기 시간
```
리스크: 백엔드 완료 전까지 대기
대응: Mock 데이터로 UI 먼저 개발
```

## 📋 일일 체크포인트

### 오전 (환경 설정 완료 체크)
- [ ] 모든 개발자 환경 설정 완료
- [ ] Git 브랜치 전략 이해
- [ ] 담당 범위 명확히 이해

### 점심 (백엔드 코어 완료 체크)
- [ ] Entity 및 Repository 동작 확인
- [ ] Service 로직 기본 테스트 통과
- [ ] API 엔드포인트 기본 동작

### 오후 (통합 진행 체크)
- [ ] 백엔드 API 완전 동작
- [ ] 프론트엔드 기본 UI 완성
- [ ] API 연동 테스트 성공

### 저녁 (최종 완성 체크)
- [ ] 전체 기능 통합 테스트 완료
- [ ] 감성 기능 (바질, 격려) 동작
- [ ] 배포 준비 완료

## 🎯 성공 지표

### 개발 완료 기준
✅ 모든 API 엔드포인트 동작
✅ 프론트엔드 기본 기능 완성
✅ 바질 성장 및 격려 메시지 동작
✅ 로컬 환경에서 완전 동작
✅ 기본 테스트 통과

### 협업 성공 기준
✅ 모든 개발자 코드 기여
✅ 큰 충돌 없이 통합 완료
✅ 일정 내 목표 달성
✅ 팀 학습 및 경험 공유

---

**팀 모토**: "완벽보다는 완성, 혼자보다는 함께!" 🤝