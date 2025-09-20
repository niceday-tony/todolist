# MVP 테스트 전략 - 하루 개발용

## 🎯 목표
5명이 하루 안에 안전하게 협업하여 MVP를 완성하기 위한 최소한의 테스트 전략

## 📋 개발자별 필수 테스트

### 백엔드 개발자 (4명)
```java
// 각자 담당 클래스의 핵심 로직만 테스트
@Test
void createTodo_Success() {
    // Given-When-Then 패턴으로 간단하게
    TodoCreateRequest request = new TodoCreateRequest("테스트");
    TodoResponse result = todoService.createTodo(request);
    assertThat(result.getTitle()).isEqualTo("테스트");
}
```

**필수 테스트 항목:**
- 할일 생성/조회/수정/삭제 각 1개씩
- 예외 상황 1개 (예: 존재하지 않는 ID)

### 프론트엔드 개발자 (1명)
```typescript
// 핵심 컴포넌트와 스토어만 테스트
test('할일 추가 성공', async () => {
  render(<TodoForm />);
  fireEvent.change(screen.getByRole('textbox'), { target: { value: '테스트' } });
  fireEvent.click(screen.getByRole('button'));
  expect(await screen.findByText('테스트')).toBeInTheDocument();
});
```

**필수 테스트 항목:**
- TodoStore 핵심 액션 3개 (추가/토글/삭제)
- 주요 컴포넌트 렌더링 3개

## 🔄 통합 검증 (공통)

### API 연동 테스트
```bash
# 수동 테스트용 간단한 스크립트
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"API 테스트"}'
```

### 핵심 시나리오 E2E (1개만!)
1. 할일 추가 → 완료 체크 → 바질 성장 확인

## 🚦 협업 규칙

### 개발 중
- 각자 코드 작성 후 간단한 테스트 실행
- PR 올리기 전 `npm test` 또는 `./gradlew test` 필수

### 통합 시
- 메인 브랜치 머지 전 전체 애플리케이션 수동 테스트
- 문제 발생시 즉시 롤백

## 🛠️ 도구 설정

### 백엔드
```gradle
// build.gradle에 추가
testImplementation 'org.springframework.boot:spring-boot-starter-test'
```

### 프론트엔드
```json
// package.json scripts
"test": "jest --watchAll=false",
"test:watch": "jest --watch"
```

## ⚡ 빠른 검증 명령어

```bash
# 백엔드 테스트
cd backend && ./gradlew test

# 프론트엔드 테스트
cd frontend && npm test

# 전체 애플리케이션 시작
docker-compose up
```

## 🎯 성공 기준

✅ **최소 요구사항**
- 각 개발자가 담당 부분 기본 테스트 작성
- PR 전 테스트 통과
- 통합 후 수동으로 핵심 기능 확인

❌ **하지 않는 것**
- 복잡한 테스트 환경 구축
- 높은 커버리지 추구
- 완벽한 자동화

---

**MVP 철학**: "완벽하지 않아도 되니까 안전하게만!"