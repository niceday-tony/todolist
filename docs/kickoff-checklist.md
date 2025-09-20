# 킥오프 체크리스트 - 5명 개발팀 총 정리

## 🎯 프로젝트 개요
**프로젝트명**: 감성적인 할일 목록
**개발 기간**: 1일 (하루 완성 MVP)
**팀 구성**: 백엔드 4명 + 프론트엔드 1명
**목표**: AI 협업을 통한 워크플로우 일관성 실험

## 📋 킥오프 미팅 전 필수 체크리스트

### 모든 개발자 공통 (미팅 전 필수)
- [ ] [개발 환경 설정 가이드](development-setup.md) 완료
- [ ] Git 환경 설정 및 브랜치 전략 숙지
- [ ] Docker Desktop 설치 및 동작 확인
- [ ] 프로젝트 클론 완료: `git clone [repository-url]`
- [ ] 담당 역할 확인 ([개발팀 계획](development-team-plan.md) 참조)

### 백엔드 개발자 추가 체크
- [ ] Java 17 설치 확인
- [ ] IntelliJ IDEA 설정 완료
- [ ] MySQL Workbench 설치 (선택사항)
- [ ] 본인 담당 영역 확인:
  - 개발자 A: API Controller 레이어
  - 개발자 B: Service 비즈니스 로직
  - 개발자 C: Data 레이어 (Entity, Repository)
  - 개발자 D: 설정 및 인프라

### 프론트엔드 개발자 추가 체크
- [ ] Node.js 18.x LTS 설치 확인
- [ ] VS Code 및 확장 프로그램 설치
- [ ] React Developer Tools 브라우저 확장

## 📚 핵심 문서 링크

### 아키텍처 & 기술 스택
- [기술 스택 명세서](architecture/tech-stack.md)
- [소스 트리 구조](architecture/source-tree.md)
- [코딩 표준 가이드](architecture/coding-standards.md)
- [API 명세서](api-specification.md)
- [프론트엔드 상태 관리](architecture/frontend-state-management.md)
- [기본 에러 처리](architecture/basic-error-handling.md)

### 협업 & 워크플로우
- [Git 워크플로우](git-workflow.md)
- [개발팀 역할 분담](development-team-plan.md)
- [MVP 테스트 전략](mvp-test-strategy.md)

## ⚡ 빠른 시작 명령어

### 전체 환경 실행
```bash
# 프로젝트 루트에서
docker-compose up -d
```

### 개별 서비스 실행 (개발 모드)
```bash
# 터미널 1: 데이터베이스
docker-compose up mysql

# 터미널 2: 백엔드 (개발자 A, B, C, D)
cd backend
./gradlew bootRun

# 터미널 3: 프론트엔드 (개발자 E)
cd frontend
npm install
npm run dev
```

### 환경 검증
```bash
# 백엔드 API 테스트
curl http://localhost:8080/api/todos

# 프론트엔드 접속
# 브라우저에서 http://localhost:3000
```

## 🕐 하루 개발 타임라인

### Phase 1: 환경 설정 (1-2시간)
- [ ] 전체팀 환경 설정 완료 확인
- [ ] Docker 환경 동작 검증
- [ ] 담당 브랜치 생성 및 첫 커밋

### Phase 2: 백엔드 코어 개발 (3-4시간)
- [ ] **개발자 C**: Entity + Repository (우선 시작)
- [ ] **개발자 B**: Service 로직 (Entity 완료 후)
- [ ] **개발자 A**: Controller (Service 완료 후)
- [ ] **개발자 D**: 설정 및 통합 (병렬 진행)

### Phase 3: 프론트엔드 개발 (3-4시간)
- [ ] **개발자 E**: 백엔드 API 완료 후 시작
- [ ] 기본 컴포넌트 → API 연동 → 감성 기능

### Phase 4: 통합 및 테스트 (1-2시간)
- [ ] 전체 기능 통합 테스트
- [ ] 감성 기능 (바질, 격려) 동작 확인
- [ ] 최종 점검 및 배포 준비

## 🤝 협업 규칙 요약

### Git 워크플로우
```bash
# 작업 시작
git checkout develop
git pull origin develop
git checkout -b feature/backend-entity

# 작업 완료 후
git add .
git commit -m "feat(backend): Todo 엔티티 구현"
git push origin feature/backend-entity
# → GitHub에서 PR 생성
```

### 커밋 메시지 형식
```
타입(스코프): 제목

타입: feat, fix, refactor, style, test, docs, chore
스코프: backend, frontend, config, test
```

### 코드 리뷰
- **백엔드**: 다른 백엔드 개발자 1명 리뷰
- **프론트엔드**: 백엔드 개발자 1명 리뷰 (API 연동 확인)
- **목표**: 30분 이내 리뷰 완료

## 🧪 테스트 전략

### 각자 최소 테스트
- **백엔드**: 담당 클래스 핵심 로직 1-2개 테스트
- **프론트엔드**: 주요 컴포넌트 렌더링 테스트 3개

### 통합 검증
```bash
# 백엔드 테스트
cd backend && ./gradlew test

# 프론트엔드 테스트
cd frontend && npm test

# 전체 애플리케이션 실행
docker-compose up
```

## 🚨 긴급 연락 체계

### 실시간 소통
- **Slack/Discord**: 즉시 질문 및 상황 공유
- **화면 공유**: 문제 발생시 즉시 공유
- **15분 체크인**: 진행 상황 공유

### 이슈 추적
- **GitHub Issues**: 버그 발견시 즉시 이슈 생성
- **담당자 지정**: 우선순위 설정 후 해결

## ✅ 성공 기준

### 개발 완료 기준
- [ ] 모든 API 엔드포인트 동작
- [ ] 프론트엔드 기본 기능 완성
- [ ] 바질 성장 및 격려 메시지 동작
- [ ] 로컬 환경에서 완전 동작
- [ ] 기본 테스트 통과

### 협업 성공 기준
- [ ] 모든 개발자 코드 기여
- [ ] 큰 충돌 없이 통합 완료
- [ ] 일정 내 목표 달성
- [ ] 팀 학습 및 경험 공유

---

## 🎬 킥오프 미팅 안건

1. **프로젝트 소개** (5분)
2. **역할 분담 확인** (10분)
3. **기술 스택 및 아키텍처 설명** (15분)
4. **Git 워크플로우 실습** (10분)
5. **개발 환경 최종 점검** (10분)
6. **일정 및 체크포인트 확인** (5분)
7. **Q&A 및 시작!** (5분)

**총 소요시간**: 60분

---

**팀 모토**: "완벽보다는 완성, 혼자보다는 함께!" 🤝

**시작 구호**: "하루 만에 MVP 완성하자! 🚀"