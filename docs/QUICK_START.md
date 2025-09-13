# 🚀 GrowTogether TodoList - 빠른 시작 가이드

## ⚡ 1분 환경 설정

### 1. 저장소 클론 및 이동
```bash
cd /Users/tony/workspace/ai/todolist
```

### 2. 개발 환경 시작
```bash
./scripts/dev-start.sh
```

이 스크립트가 자동으로 확인/설정합니다:
- ✅ 시스템 요구사항 (Java 17, Node.js, Docker)
- ✅ MySQL 컨테이너 시작
- ✅ 데이터베이스 생성
- ✅ 의존성 설치

---

## 📋 스토리별 개발 가이드

### 📍 **현재 상황**: 아키텍처 완료, 스토리 생성 완료
### 📍 **다음 단계**: Story 1.1부터 순서대로 구현

---

## 🎯 Story 1.1: Foundation & Database Setup (2시간)

### ✅ 체크리스트
- [ ] Spring Boot 프로젝트 생성
- [ ] React 프로젝트 생성
- [ ] MySQL 연결 확인
- [ ] JPA 엔티티 생성
- [ ] 크로스 서비스 통신 테스트

### 🔧 구현 순서
```bash
# 1. 백엔드 생성 (Spring Initializr)
# Dependencies: Web, Data JPA, MySQL Driver, Validation

# 2. 프론트엔드 생성
cd frontend
npm create vite@latest . -- --template react-ts
npm install axios react-router-dom

# 3. 연결 테스트
# 백엔드: mvn spring-boot:run
# 프론트엔드: npm run dev
```

**⚠️ 중요**: Story 1.1이 100% 완료된 후에만 Story 1.2 시작!

---

## 🎯 Story 1.2: Basic TODO Management (1.5시간)

### ✅ 체크리스트
- [ ] DTO 클래스 생성
- [ ] TodoRepository 구현
- [ ] TodoService 비즈니스 로직
- [ ] TodoController REST API
- [ ] React TODO 컴포넌트

### 🔧 구현 순서
```bash
# 계층별 순서 준수 (절대 변경 금지)
# DTO → Repository → Service → Controller → Frontend
```

---

## 🎯 Story 1.3: Plant Companion System (2시간)

### ✅ 체크리스트
- [ ] PlantGrowthService 로직
- [ ] Plant API 엔드포인트
- [ ] TODO-Plant 통합 (@Transactional)
- [ ] 식물 이미지/SVG 준비
- [ ] PlantView 컴포넌트

**💡 핵심**: 성장 알고리즘 = `min(5, floor(growthPoints / 20) + 1)`

---

## 🎯 Story 1.4: Growth Animation & Feedback (1.5시간)

### ✅ 체크리스트
- [ ] CSS 애니메이션 정의
- [ ] 축하 메시지 시스템
- [ ] useGrowthAnimation Hook
- [ ] 60fps 성능 확인
- [ ] 접근성 지원

**🎨 중요**: 1초 이내 피드백, 60fps 애니메이션 필수

---

## 🎯 Story 1.5: Integrated Dashboard UI (1.5시간)

### ✅ 체크리스트
- [ ] 디자인 시스템 (CSS 토큰)
- [ ] 반응형 레이아웃
- [ ] 시각적 연결 효과
- [ ] WCAG AA 접근성
- [ ] 모바일 최적화

**🎨 목표**: 프로페셔널한 통합 UI 완성

---

## 🛠️ 개발 도구 사용법

### 빌드 스크립트
```bash
# 개발 빌드
./scripts/build-all.sh --dev

# 프로덕션 빌드
./scripts/build-all.sh --prod

# 테스트 포함 빌드
./scripts/build-all.sh --test --clean
```

### 테스트 스크립트
```bash
# 유닛 테스트만 (빠름)
./scripts/test-all.sh --unit

# 통합 테스트
./scripts/test-all.sh --integration

# 모든 테스트 + 리포트
./scripts/test-all.sh --all --report
```

### 개발 서버 시작
```bash
# 환경 확인 + 선택적 시작
./scripts/dev-start.sh

# 또는 수동 시작
# 터미널 1: cd backend && mvn spring-boot:run
# 터미널 2: cd frontend && npm run dev
```

---

## 📚 주요 문서

| 문서 | 목적 |
|------|------|
| `docs/prd.md` | 제품 요구사항 |
| `docs/architecture.md` | 백엔드 아키텍처 |
| `docs/ui-architecture.md` | 프론트엔드 아키텍처 |
| `docs/DEVELOPMENT_SEQUENCE.md` | **개발 순서 가이드** ⭐ |
| `docs/stories/1.*.md` | **실행 가능한 개발 스토리** ⭐ |

---

## 🎯 성공 기준

### Epic 1 완료 시점
- ✅ TODO 생성/완료 가능
- ✅ 식물이 5단계로 성장
- ✅ 애니메이션으로 즉시 피드백
- ✅ 통합 대시보드 UI
- ✅ 모든 기능이 1초 이내 반응

### 품질 기준
- ✅ 60fps 애니메이션
- ✅ WCAG AA 접근성
- ✅ Chrome/Firefox/Safari 지원
- ✅ 모바일 반응형
- ✅ 데이터베이스 영구 저장

---

## 🆘 문제 해결

### MySQL 연결 실패
```bash
docker-compose down
docker-compose up -d mysql
```

### 포트 충돌
```bash
# 8080 포트 확인
lsof -i :8080
kill -9 <PID>

# 3000 포트 확인
lsof -i :3000
kill -9 <PID>
```

### 빌드 오류
```bash
# 백엔드 clean
cd backend && mvn clean compile

# 프론트엔드 clean
cd frontend && rm -rf node_modules package-lock.json && npm install
```

---

## ⏰ 시간 분배 (총 8시간)

- **Story 1.1**: 2시간 (기반 구축)
- **Story 1.2**: 1.5시간 (TODO 기능)
- **Story 1.3**: 2시간 (식물 시스템)
- **Story 1.4**: 1.5시간 (애니메이션)
- **Story 1.5**: 1시간 (UI 통합)

**💡 팁**: 각 스토리 완료 후 15분 휴식 권장

---

## 🎉 최종 결과

1일 후 완성될 **GrowTogether TodoList**:
- 🌱 TODO 완료시 식물이 성장하는 감정적 보상 시스템
- ✨ 부드러운 60fps 애니메이션과 축하 메시지
- 📱 데스크톱/모바일 반응형 UI
- ♿ WCAG AA 접근성 준수
- 💾 MySQL 기반 안정적인 데이터 저장

**지금 시작하세요!** 🚀

```bash
./scripts/dev-start.sh
```