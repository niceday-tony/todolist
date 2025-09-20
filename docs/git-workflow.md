# Git 워크플로우 및 협업 규칙

## 🌿 브랜치 전략

### 브랜치 구조
```
main
├── develop
│   ├── feature/backend-entity (개발자 C)
│   ├── feature/backend-service (개발자 B)
│   ├── feature/backend-controller (개발자 A)
│   ├── feature/backend-config (개발자 D)
│   └── feature/frontend-ui (개발자 E)
└── hotfix/critical-bug (긴급 수정시)
```

### 브랜치 역할

#### `main` 브랜치
- **목적**: 최종 배포 가능한 안정 버전
- **보호**: Direct push 금지
- **머지**: develop → main (최종 배포시)

#### `develop` 브랜치
- **목적**: 개발 통합 브랜치
- **머지**: feature → develop (기능 완료시)
- **테스트**: 통합 테스트 진행

#### `feature/` 브랜치
- **명명**: `feature/영역-기능명`
- **예시**: `feature/backend-entity`, `feature/frontend-todo-list`
- **수명**: 기능 완료시까지

## 🚀 개발 워크플로우

### 1단계: 브랜치 생성 및 시작

```bash
# develop에서 최신 코드 받기
git checkout develop
git pull origin develop

# 기능 브랜치 생성
git checkout -b feature/backend-entity

# 첫 커밋 (브랜치 생성 알림)
git commit --allow-empty -m "feat: Todo Entity 개발 시작"
git push -u origin feature/backend-entity
```

### 2단계: 개발 및 커밋

```bash
# 작업 진행 후 커밋
git add .
git commit -m "feat: Todo 엔티티 기본 구조 구현"

# 중간 푸시 (백업 및 공유)
git push origin feature/backend-entity

# 추가 작업 후
git commit -m "feat: Todo 엔티티 유효성 검증 추가"
git push origin feature/backend-entity
```

### 3단계: Pull Request 생성

```markdown
PR 템플릿:

## 🎯 변경사항
- Todo 엔티티 기본 구조 구현
- JPA 어노테이션 설정
- 기본 유효성 검증 추가

## ✅ 체크리스트
- [x] 코딩 컨벤션 준수
- [x] 기본 테스트 작성
- [x] API 명세서와 일치
- [ ] 통합 테스트 확인 필요

## 📝 리뷰 포인트
- Entity 필드 설계 적절성
- JPA 매핑 전략 검토

## 🔗 관련 이슈
- #1 Todo Entity 구현
```

### 4단계: 코드 리뷰 및 머지

```bash
# 리뷰 피드백 반영 후
git add .
git commit -m "fix: 리뷰 피드백 반영 - 필드명 수정"
git push origin feature/backend-entity

# 승인 후 develop에 머지 (GitHub에서)
# 머지 완료 후 로컬 정리
git checkout develop
git pull origin develop
git branch -d feature/backend-entity
```

## 📝 커밋 메시지 컨벤션

### 기본 형식
```
타입(스코프): 제목

본문 (선택사항)

푸터 (선택사항)
```

### 타입 정의
```
feat: 새로운 기능 추가
fix: 버그 수정
refactor: 코드 리팩토링
style: 코드 포맷팅 (세미콜론 누락, 공백 등)
test: 테스트 코드 추가/수정
docs: 문서 수정
chore: 빌드 프로세스, 패키지 매니저 설정 등
```

### 스코프 예시
```
backend: 백엔드 관련
frontend: 프론트엔드 관련
config: 설정 관련
test: 테스트 관련
```

### 커밋 메시지 예시

#### 좋은 예시 ✅
```bash
git commit -m "feat(backend): Todo 엔티티 구현

- JPA 어노테이션 설정
- 기본 유효성 검증 추가
- created_at, updated_at 자동 설정

관련 이슈: #1"

git commit -m "fix(frontend): 할일 추가시 폼 리셋 안되는 버그 수정"

git commit -m "refactor(backend): TodoService 메서드 분리로 가독성 향상"
```

#### 나쁜 예시 ❌
```bash
git commit -m "수정"
git commit -m "버그픽스"
git commit -m "작업완료"
```

## 🔄 협업 규칙

### 코드 리뷰 규칙

#### 리뷰어 지정
- **백엔드**: 다른 백엔드 개발자 1명 + 아키텍트
- **프론트엔드**: 백엔드 개발자 1명 (API 연동 확인용)

#### 리뷰 기준
```
필수 체크:
✅ 코딩 컨벤션 준수
✅ API 명세서와 일치
✅ 기본 테스트 존재
✅ 보안 이슈 없음

선택 체크:
🔍 성능 개선 가능성
🔍 코드 가독성
🔍 재사용성
```

#### 리뷰 시간
- **목표**: 30분 이내 리뷰 완료
- **긴급시**: 즉석에서 화면 공유 리뷰

### 충돌 해결 전략

#### 예방
```bash
# 작업 시작 전 최신 develop 동기화
git checkout develop
git pull origin develop
git checkout feature/my-branch
git rebase develop

# 자주 동기화 (하루 2-3번)
git fetch origin develop
git rebase origin/develop
```

#### 충돌 발생시
```bash
# 1. 충돌 파일 확인
git status

# 2. 충돌 해결 (IDE에서)
# <<<<<<< HEAD
# 내 코드
# =======
# 다른 사람 코드
# >>>>>>> branch명

# 3. 해결 후 계속 진행
git add .
git rebase --continue

# 4. 강제 푸시 (rebase 후)
git push --force-with-lease origin feature/my-branch
```

### 긴급 상황 대응

#### Hotfix 프로세스
```bash
# main에서 긴급 수정 브랜치 생성
git checkout main
git checkout -b hotfix/critical-bug

# 수정 및 테스트
git commit -m "hotfix: 중요한 버그 긴급 수정"

# main과 develop 모두에 머지
git checkout main
git merge hotfix/critical-bug
git checkout develop
git merge hotfix/critical-bug
```

## 📊 브랜치 보호 규칙

### GitHub 브랜치 보호 설정

#### `main` 브랜치
```yaml
보호 설정:
- Direct push 금지
- PR 필수
- 리뷰 승인 필수 (최소 1명)
- 머지 전 최신 상태 확인
- Delete 브랜치 금지
```

#### `develop` 브랜치
```yaml
보호 설정:
- Direct push 금지
- PR 필수
- 기본 테스트 통과 필수
- Squash merge 사용
```

## 🎯 일일 Git 체크포인트

### 아침 시작시
```bash
# 최신 코드 동기화
git checkout develop
git pull origin develop

# 새로운 하루 작업 브랜치 업데이트
git checkout feature/my-branch
git rebase develop
```

### 점심시간
```bash
# 진행사항 백업
git add .
git commit -m "WIP: 중간 저장 - 점심 전 백업"
git push origin feature/my-branch
```

### 퇴근 전
```bash
# 하루 작업 정리
git add .
git commit -m "feat: 오늘 작업 완료 - 상세 설명"
git push origin feature/my-branch

# PR 생성 (기능 완료시)
```

## 🔧 유용한 Git 명령어

### 빠른 작업용 별칭
```bash
# .gitconfig에 추가
[alias]
  co = checkout
  br = branch
  ci = commit
  st = status
  unstage = reset HEAD --
  last = log -1 HEAD
  visual = !gitk
  cp = cherry-pick
  sync = !git checkout develop && git pull origin develop
  new = checkout -b
  done = !git checkout develop && git pull origin develop && git branch -d
```

### 사용 예시
```bash
git sync                    # develop 최신화
git new feature/my-work     # 새 브랜치 생성
git st                      # 상태 확인
git ci -m "feat: 작업완료"  # 커밋
git done feature/my-work    # 브랜치 정리
```

---

**Git 협업 원칙**: "자주 동기화, 작은 단위 커밋, 명확한 메시지!" 🤝